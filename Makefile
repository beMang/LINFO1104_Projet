TWEETS_FOLDER="tweets"
UNAME_S := $(shell uname -s)
ENTRY_POINT=main.ozf
ENTRY_TEST=src/tests.ozf

#Pour activer ou désactiver les extensions :
EXTENSIONS = --custom_dataset true --history true --automatic false --better_parse true --more_gramme true

ifeq ($(UNAME_S),Darwin)
	OZC = /Applications/Mozart2.app/Contents/Resources/bin/ozc
	OZENGINE = /Applications/Mozart2.app/Contents/Resources/bin/ozengine
else
	OZC = ozc
	OZENGINE = ozengine
endif

all : src/possibility.ozf src/tree.ozf src/str.ozf src/files.ozf src/parse.ozf src/GUI.ozf src/save.ozf main.ozf
	make $^

%.ozf: %.oz
	$(OZC) -c $< -o "$@"

run: $(ENTRY_POINT)
	$(OZENGINE) $(ENTRY_POINT) --folder $(TWEETS_FOLDER) $(EXTENSIONS)

clean :
	rm -f **/*.ozf
	rm -f *.ozf

tests : tests.ozf
	make
	make $^
	$(OZENGINE) $(ENTRY_TEST) --folder $(TWEETS_FOLDER)

.PHONY: tests