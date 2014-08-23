How to use the Squiggly SDK
===================================

Please read the ASDoc first to understand the classes in Squiggly.

If you are using the SpellChecker class directly, you need.
- AdobeSpellingEngine.swc in [YourProject]/libs folder, you can find it from ./libs
- Dictionary files in [YourProject]/src folder, your can find them from ./src/dictionaries folder

If you are using the simple UI integration feature (SpellUI class), in addition to what mentioned above, you also need
- AdobeSpellingConfig.xml in [YourProject]/src
- AdobeSpellingUI.swc (AdobeSpellingUIEx.swc if you need spark support in Flex 4) in [YourProject]/libs 

This SDK came with English(US) dictionary. You can download additional HunSpell dictionaries, but for now, what we have tested are just English, Spanish, Portuguese, Italian and French. If you are doing this, you need to understand AdobeSpellingConfig.xml.

Here's the content of AdobeSpellingConfig.xml, each entry maps the languageCode with the relative path for resource files. 
<SpellingConfig>
  <LanguageResource language="English" languageCode="en_US" ruleFile="dictionaries/en_US/en_US.aff" dictionaryFile="dictionaries/en_US/en_US.dic"/>
</SpellingConfig>

So if you are adding Spanish, you just need to get the hunspell dictionary es_ES.aff/dic and add one line to your config file.
  <LanguageResource language="Spanish" languageCode="es_ES" ruleFile="dictionaries/es_ES/es_ES.aff" dictionaryFile="dictionaries/es_ES/es_ES.dic"/>

Note that you can put the dictionaries in another location as long as you update the config file, the config file itself MUST be in [YourProject]/src folder.




