Squiggly Dictionary Generator v0.1

README
===================================

This is a simple AIR application that converts a plain text word list file to an Adobe Spelling Dictionary file. 

Here's what each step is doing:
1. Load a plain text file, each line in the file contains one word, a sampleWOrdList.txt is provided
2. Calculate the metaphone, which will improve spell checker performance and result
3. Generate a Squiggly Dictionary object
4. Export the the Squiggly Dictionary object to a compressed binary file (recommend using *.zwl extension)

Once you have the zwl file, you can use it in your Flex/AIR project.


