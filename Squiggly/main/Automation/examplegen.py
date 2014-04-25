import shutil, os, stat, re, errno

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Source and destination paths
asdocExamplePath = "../ASDocExamples/com/adobe/linguistics/spelling/Examples"
packageExamplePath = "./Release/SquigglySDK/Examples"

# Go over all mxml files and modify them
def modifyAll():
    for root, dirs, files in os.walk(packageExamplePath):
        for filename in files:
            if '.mxml' in filename:
                modifyMxml(os.path.join(root, filename))
                
# Modify one mxml file by removing all asdoc comments
def modifyMxml(filename):
    print filename + "....."
    code = file(filename, 'r').read()
    code = removeComment(code)
    if (not os.stat(filename)[0] & stat.S_IWRITE):
        os.chmod(filename, stat.S_IWRITE)
    file(filename, 'w').write(code)

# Remove asdoc comment, we don't remove // comment
def removeComment(text):
    def replacer(match):
        s = match.group(0)
        if s.startswith('/'):
            return ""
        else:
            return s
    pattern = re.compile(
        r'/\*.*?\*/|\'(?:\\.|[^\\\'])*\'|"(?:\\.|[^\\"])*"',
        re.DOTALL | re.MULTILINE
    )
    return re.sub(pattern, replacer, text)

# Remove a readonly file, required by windows
def removeReadonly(func, path, exc):
  excvalue = exc[1]
  if func in (os.rmdir, os.remove) and excvalue.errno == errno.EACCES:
      os.chmod(path, stat.S_IWRITE)
      func(path)
  else:
      raise

# Main function
def main():
    print "Removing the asdoc comments from mxml source code"
    if os.path.isdir(packageExamplePath):
        shutil.rmtree(packageExamplePath, onerror=removeReadonly)
    shutil.copytree(asdocExamplePath, packageExamplePath)
    modifyAll()
    print "Done! Check " + packageExamplePath + " for example code."

if __name__ == '__main__':
    main()
        
    

