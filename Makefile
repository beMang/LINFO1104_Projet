TWEETS_FOLDER="tweets" #si pas envie d'attendre à chaque fois mettre smaller_data pour plus petit set de donnée
UNAME_S := $(shell uname -s)
ENTRY_POINT=main.ozf
ENTRY_TEST=tests/tests.ozf

ifeq ($(UNAME_S),Darwin)
	OZC = /Applications/Mozart2.app/Contents/Resources/bin/ozc
	OZENGINE = /Applications/Mozart2.app/Contents/Resources/bin/ozengine
else
	OZC = ozc
	OZENGINE = ozengine
endif

all : src/possibility.ozf src/tree.ozf src/str.ozf src/files.ozf src/parse.ozf src/GUI.ozf src/save.ozf main.ozf tests/tests.ozf
	make $^

%.ozf: %.oz
	$(OZC) -c $< -o "$@"

run: $(ENTRY_POINT)
	$(OZENGINE) $(ENTRY_POINT) --folder $(TWEETS_FOLDER)

clean :
	rm -f **/*.ozf
	rm -f *.ozf

tests :
	$(OZENGINE) $(ENTRY_TEST) --folder $(TWEETS_FOLDER)

.PHONY: tests