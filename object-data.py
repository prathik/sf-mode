#!/usr/bin/python

from subprocess import Popen, PIPE
import json
import sys


class ObjectData():

    def __init__(self, name, forcePath):
        self.name = name
        self.path = forcePath

    def _get_object_meta(self):

        response = Popen([self.path,
                          "describe",
                          "-t",
                          "sobject",
                          "-n",
                          self.name,
                          "-json"], stdout=PIPE).stdout.read()
        return json.loads(response)

    def get_fields(self):
        return [
            x['name'] for x in
            self._get_object_meta()['fields']]

if __name__ == '__main__':
    d = ObjectData(sys.argv[1],
                   "/Users/prathik.raj/Downloads/force")
    for x in d.get_fields():
        print x
