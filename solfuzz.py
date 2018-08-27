#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import logging
import subprocess,os
import json, collections, copy, time
from shutil import copyfile

DEVNULL= open(os.devnull, 'w')

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

ch = logging.StreamHandler()
ch.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
ch.setFormatter(formatter)
logger.addHandler(ch)


PROD_CONFIG = {
    "sourcedir"   : "/tmp/datadrive/solidity",
    "fuzzbins"    : "/tmp/datadrive/fuzzbins",
    "wwwroot"     : "/tmp/datadrive/www-data",
    "tasks" : [
        { "name": "solfuzzer" ,"desc" : "Solidity standard", "in": "/datadrive/solidity_input/", "args": ""},
        { "name": "solfuzzer_json", "desc" : "Solidity JSON ", "in": "/datadrive/solidity_json_input/", "args": "--standard-json"}
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


            self.meta["repo"] = _origin.decode().strip()
            self.meta["branch"] = _branch.decode().strip()
            self.meta["hash"] = _hash.decode().strip() 

        except subprocess.CalledProcessError as cpe:
            self.meta['status'] = "Code update failed: %s" % str(cpe)
            self.errored = True
            return False

        logging.info("Code at revision %s" % _hash.strip())


    def compileCode(self):

        self.meta['status'] = "Compiling"
        sourcedir = self.config['sourcedir']
        cmd = "cmake -DCMAKE_CXX_COMPILER=afl-g++ -DCMAKE_C_COMPILER=afl-gcc ..".split(" ")
        builddir = "%s/build" % sourcedir
 
        try:

            logger.info("Invoking cmake")
            subprocess.check_call(cmd, cwd=builddir) 
            logger.info("Invoking make")
            subprocess.check_call(["make"], cwd=builddir) 

        except subprocess.CalledProcessError as cpe:
            self.meta['status'] = "Compilation failed: %s" % str(cpe)
            self.errored = True
            return False

        logging.info("Compilation done" )


    def copyBins(self):
        """Copy the binaries""" 

        self.meta['status'] = "Copying files"
        bindir = self.config['fuzzbins']

        tag = self.meta['hash']
        dest = "%s/solfuzzer%s" % (bindir, tag)
        copyfile("%s/build/test/tools/solfuzzer" %  self.config['sourcedir'], dest)

        self.meta['bin'] = dest
        os.chmod(dest, 771)
        logging.info("Copied into %s" % dest )


    def startFuzzers(self, task):
        self.meta['status'] = "Starting fuzzers"

        name = task['name']
        output = "%s/solidity/%s-@%s" % (self.config['output'] ,task['name'], self.meta['hash'])


        # If the sync-dir already exist, AFL will not overwrite it. We can instead choose to resume, 
        # by setting '-i-' as input
        if(os.path.isdir(output)):
            logging.info("Output dir exists already, resuming...")
            cmds = [
                ["afl-fuzz", "-m","100","-i-" ,"-o",output,"-M", "master" ,self.meta['bin'], task['args']],
                ["afl-fuzz", "-m","100","-i-" ,"-o",output,"-S", "slave1" ,self.meta['bin'], task['args']],
                ["afl-fuzz", "-m","100","-i-" ,"-o",output,"-S", "slave2" ,self.meta['bin'], task['args']],
            ]
        else:
            cmds = [
                ["afl-fuzz", "-m","100","-i" ,task['in'],"-o",output,"-M", "master" ,self.meta['bin'], task['args']],
                ["afl-fuzz", "-m","100","-i" ,task['in'],"-o",output,"-S", "slave1" ,self.meta['bin'], task['args']],
                ["afl-fuzz", "-m","100","-i" ,task['in'],"-o",output,"-S", "slave2" ,self.meta['bin'], task['args']],
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
        print(self.meta['status'])
        for task in self.config['tasks']:
            output = "/solidity/%s-@%s" % ( task['name'], self.meta['hash'])
            syncdir = "%s/%s" % (self.config['wwwroot'] ,output)

            try:
                status = subprocess.check_output(["afl-whatsup", syncdir]).decode()
            except subprocess.CalledProcessError as cpe:
                status = "Status check failed: %s" % str(cpe)
                self.errored = True
            except Exception as e:
                status = str(e)
                self.errored = True

            info.append({'desc' : task['desc'], "status" : status, "output" : output})
        self.meta['fuzzers'] = info
        self.meta['errored'] = self.errored
        return self.meta

    def writeStatus(self):
        """

        """
        self.dumpJson(self.status(), "fuzzing.json")



    def startWork(self):
        while True:
            self.doUpdate = False
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

            while not self.doUpdate:
                self.createArchive()    
                try:
                    time.sleep(60)
                except KeyboardInterrupt:
                    self.quit()
                    return
            self.killProcs()

    def start(self):
        self.startWork()
        try:
            while True:
                self.createArchive()    
                self.writeStatus()
                time.sleep(10)
        except KeyboardInterrupt:
            self.quit()

    def createArchive(self):

        cmd = ["tar","-cvzf","results-%s.tar.gz" % self.meta['hash']]
        # Add directories
        for task in self.config['tasks']:
            cmd.append( "%s/solidity/%s-@%s/master/crashes" % (self.config['output'], task['name'], self.meta['hash'])  )
            cmd.append( "%s/solidity/%s-@%s/slave1/crashes" % (self.config['output'], task['name'], self.meta['hash'])  )
            cmd.append( "%s/solidity/%s-@%s/slave2/crashes" % (self.config['output'], task['name'], self.meta['hash'])  )


        subprocess.call(cmd, cwd="%s" % self.config['wwwroot'])

        self.meta['archive'] =  "results-%s.tar.gz" % self.meta['hash']

    def killProcs(self):
        self.status = "Killing processes"
        for proc in self.procs:
            logging.info("Killing proc : %d" % proc.pid)
            proc.terminate()
        self.procs = []

    def quit(self):
        logging.info("Quitting")
        self.killProcs()
        DEVNULL.close()


    def updateAndRestart():
        self.doUpdate = True

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    Fuzzer(PROD_CONFIG).start()

