TWEETS_FOLDER="tweets" #si pas envie d'attendre à chaque fois mettre smaller_data pour plus petit set de donnée
UNAME_S := $(shell uname -s)
ENTRY_POINT=main.ozf
ENTRY_TEST=tests.ozf

#Pour activer ou désactiver les extensions :
EXTENSIONS= --custom_dataset false --history false --automatic false --more_gramme false --better_parse false

ifeq ($(UNAME_S),Darwin)
	OZC = /Applications/Mozart2.app/Contents/Resources/bin/ozc
	OZENGINE = /Applications/Mozart2.app/Contents/Resources/bin/ozengine
else
	OZC = ozc
	OZENGINE = ozengine
endif

all : possibility.ozf tree.ozf str.ozf files.ozf parse.ozf GUI.ozf save.ozf main.ozf
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