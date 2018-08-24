#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import logging
import subprocess,os
import json, collections, copy, time
from shutil import copyfile

DEVNULL= open(os.devnull, 'w')

PROD_CONFIG = {
    "sourcedir"   : "/datadrive/solidity",
    "fuzzbins"    : "/datadrive/fuzzbins",
    "wwwroot"     : "/datadrive/www-data",
    "tasks" : [
        { "name": "solfuzz" ,"desc" : "Solidity standard", "in": "/datadrive/solidity_input/", "args": ""},
        { "name": "solfuzz_json", "desc" : "Solidity JSON ", "in": "/datadrive/solidity_json_input/", "args": "--standard-json"}
    ]
}

class Fuzzer(object):

    def __init__(self, config):
        self.config = config
        self.procs = []
        self.meta = collections.defaultdict(lambda:"NA")
        os.makedirs(config['sourcedir'], exist_ok = True)
        os.makedirs(config['fuzzbins'], exist_ok = True)
        os.makedirs(config['wwwroot'], exist_ok = True)
        self.errored = False

    def fetchCode(self):
        
        self.meta.clear()
        self.meta['status'] = "Updating sourcecode"

        sourcedir = self.config["sourcedir"]

        if not os.path.isdir(sourcedir):
            self.meta['status'] = "Error, source directory is empty"               
            self.errored = True
            return

        try:
            subprocess.check_output(["git", "pull"],cwd=sourcedir)
            _origin=subprocess.check_output(["git","config","--get","remote.origin.url"],cwd=sourcedir)
            _branch=subprocess.check_output(["git","branch"],cwd=sourcedir)
            _hash=subprocess.check_output(["git","log","--pretty=format:%h","-n","1"],cwd=sourcedir)


            self.meta["repo"] = _origin.strip()
            self.meta["branch"] = _branch.strip()
            self.meta["hash"] = _hash.strip() 

        except subprocess.CalledProcessError as cpe:
            self.meta['status'] = cpe.output
            self.errored = True
            return False

        logging.info("Code at revision %s" % _hash.strip())


    def compileCode(self):

        self.meta['status'] = "Compiling"
        sourcedir = self.config['sourcedir']
        cmd = "cmake -DCMAKE_CXX_COMPILER=afl-g++ -DCMAKE_C_COMPILER=afl-gcc ..".split(" ")
        builddir = "%s/build" % sourcedir
 
        try:

            subprocess.check_call(cmd, cwd=builddir) 
            subprocess.check_call(["make"], cwd=builddir) 

        except subprocess.CalledProcessError as cpe:
            self.meta['status'] = cpe.output
            self.errored = True
            return False

        logging.info("Compilation done" )


    def copyBins(self):
        """Copy the binaries""" 

        self.meta['status'] = "Copying files"
        bindir = self.config['fuzzbins']

        builddir = "%s/build" % self.config['sourcedir']
        tag = self.meta['hash']
        dest = "%s/solfuzzer_%s" % (bindir, tag)
        copyfile("%s/test/solfuzzer" % builddir, dest)

        self.meta['bin'] = dest
        os.chmod(dest, 771)
        logging.info("Copied into %s" % dest )


    def startFuzzers(self, task):
        self.meta['status'] = "Starting fuzzers"

        name = task['name']
        output = "%s/solidity/%s-@%s" % (self.config['wwwroot'] ,task['name'], self.meta['hash'])

        cmds = [
            ["afl-fuzz", "-i" ,task['in'],"-o",output,"-M", "master" ,self.meta['bin'], task['args']],
            ["afl-fuzz", "-i" ,task['in'],"-o",output,"-S", "slave1" ,self.meta['bin'], task['args']],
            ["afl-fuzz", "-i" ,task['in'],"-o",output,"-S", "slave2" ,self.meta['bin'], task['args']],
        ]

        for cmd in cmds:
            logging.info("Starting %s" % (" ".join(cmd)))
            self.procs.append(subprocess.Popen(cmd, stdout=DEVNULL))

        task['syncdir'] = output
        task['pids'] = [x.pid for x in self.procs] 
        self.meta['status'] = "Running fuzzers"


    def dumpJson(self, obj, fname):
        fullpath ="%s/%s" % (self.config['wwwroot'], fname)
        with open(fullpath , "w+") as outfile:
            json.dump(obj, outfile )
            logging.info("Wrote to %s" % fullpath )

    def status(self):
        info = []
        for task in self.config['tasks']:
            output = "/solidity/%s-@%s" % ( task['name'], self.meta['hash'])
            syncdir = "%s/%s" % (self.config['wwwroot'] ,output)

            try:
                status = subprocess.check_output(["afl-whatsup", syncdir])
            except subprocess.CalledProcessError as cpe:
                status = cpe.output
                self.errored = True
            except Exception as e:
                status = str(e)
                self.errored = True

            info.append({'desc' : task['desc'], "status" : status, "output" : output})
        self.meta['fuzzers'] = info
        return self.meta

    def writeStatus(self):
        """

        """
        self.dumpJson(self.status(), "fuzzing.json")

    def startWork(self):
        self.fetchCode()
        if self.errored:
            return
        self.compileCode()
        if self.errored:
            return
        self.copyBins()
        if self.errored:
            return
        jobs = []
        for task in self.config['tasks']:
            jobs.append(self.startFuzzers(task))


    def start(self):
        self.startWork()
        try:
            while True:
                self.createArchive()    
                self.writeStatus()
                time.sleep(10)
        except KeyboardInterrupt:
            self.quit()

    def createArchive(self, meta):

        cmd = ["tar","-cvzf","results-%s.tar.gz" % self.meta['hash']]
        # Add directories
        for task in self.config['tasks']:
            cmd.append( "%s-@%s/master/crashes" % (task['name'], self.meta['hash'])  )
            cmd.append( "%s-@%s/slave1/crashes" % (task['name'], self.meta['hash'])  )
            cmd.append( "%s-@%s/slave2/crashes" % (task['name'], self.meta['hash'])  )


        subprocess.call(cmd, cwd="%s/solidity/" % self.config['wwwroot'])

        self.meta['archive'] =  "/solidity/results-%s.tar.gz" % self.meta['hash']

    def quit(self):
        logging.info("Quitting")
        for proc in self.procs:
            logging.info("Killing proc : %d" % proc.pid)
            proc.terminate()
            DEVNULL.close()


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    Fuzzer(PROD_CONFIG).start()

