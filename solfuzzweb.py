#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import solfuzz, sys, os, threading
import logging
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
    ]
}

fuzzer = solfuzz.Fuzzer(DEV_CONFIG)
 
@app.route("/")
def index():
    return flask.render_template("index.html", status = fuzzer.status(), config = fuzzer.config)

@app.route("/download/")
@app.route("/download/<artefact>")
def download(artefact = None):
    """ Download a file -- only artefacts allowed """

    artefactDir = fuzzer.cfg.artefacts
    print("downlaod '%s'" % artefact)
    if artefact == None or artefact.strip() == "":
        # file listing
        return flask.render_template("listing.html", files = sorted(os.listdir(artefactDir), reverse=True) )

    insecure_fullpath = os.path.realpath(os.path.join(artefactDir, artefact))
    # Now check that the path is a subdir of artefact idr
    if not insecure_fullpath.startswith(artefactDir):
        return "Meh, nice try"

    return flask.send_from_directory(artefactDir, artefact, as_attachment=True)


def main():
    host = "localhost"
    port = 8080
    # Start all docker daemons that we'll use during the execution
    fuzzer.startWork()
    app.run(host, port)

if __name__ == '__main__':
#    testSummary()
    main()
