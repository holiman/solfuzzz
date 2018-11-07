#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import solfuzz, sys, os, threading
import logging, json, glob
logger = logging.getLogger()

try:
    import flask
    templates = os.path.abspath(os.path.join(os.path.dirname(__file__), 'templates'))
    app = flask.Flask(__name__, template_folder=templates)
    logger.info("Flask init: template_folder: %s" % templates)
except ImportError:
    logger.warning("Flask not installed, disabling web mode")
    sys.exit(1)



DEV_CONFIG = {
    "sourcedir"   : "/tmp/solfuzz/solidity",
    "fuzzbins"    : "/tmp/solfuzz/fuzzbins",
    "wwwroot"     : "/tmp/solfuzz/www-data",
    "tasks" : [
        { "name": "solfuzz" ,"desc" : "Solidity standard", "in": "/datadrive/solidity_input/", "args": ""},
        { "name": "solfuzz_json", "desc" : "Solidity JSON ", "in": "/datadrive/solidity_json_input/", "args": "--standard-json"}
    ],
    "host":"localhost",
    "port": 8080
}

@app.route("/update")
def update():
    fuzzer.updateAndRestart()
    return flask.redirect("/", code=302)

@app.route("/")
def index():

    artefactsDir = os.path.abspath(os.path.join(fuzzer.config['wwwroot'],"*.tar.gz"))
    files = glob.glob(artefactsDir)
    files.sort(key=os.path.getmtime, reverse=True)

    return flask.render_template("index.html", 
            status = fuzzer.status(), 
            config = fuzzer.config, 
            files=[os.path.basename(x) for x in files])

@app.route("/download/")
@app.route("/download/<artefact>")
def download(artefact = None):
    """ Download a file -- only artefacts allowed """

    artefactDir = fuzzer.config["wwwroot"]

    insecure_fullpath = os.path.realpath(os.path.join(artefactDir, artefact))
    # Now check that the path is a subdir of artefact idr
    if not insecure_fullpath.startswith(artefactDir):
        return "Meh, nice try"

    return flask.send_from_directory(artefactDir, artefact, as_attachment=True)

fuzzer = None

def flaskRunner(host, port ):
    app.run(host, port)


def main(args):
    global fuzzer
    config = DEV_CONFIG

    if len(args) > 0:    
        with open(args[0]) as fp:
            config = json.load(fp)        

    # Start all docker daemons that we'll use during the execution

    thread = threading.Thread(target=flaskRunner, args = (config['host'], config['port']))
    thread.start()

    fuzzer = solfuzz.Fuzzer(config)
    fuzzer.startWork()
    thread.join()
    
if __name__ == '__main__':
#    testSummary()
    main(sys.argv[1:])
