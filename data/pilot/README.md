# Data README file

**Dataset title:** Clean data from pilot study for project on "Cross-Cultural
Trust in Artificial Moral Advisors"

**Principal investigator:** Dr. Scott Claessens (scott.claessens@gmail.com)

**Head researcher:** Dr. Jim Everett (j.a.c.everett@kent.ac.uk)

**Institution:** University of Kent

**File format:** CSV file

**File dimensions:** 800 rows x 24 columns

**Data collected on:** 30th January 2025

**Columns in the dataset:**

- `id` - numeric, participant identification number
- `treatment` - character, randomly assigned treatment
- `attention` - character, response to the attention check question. The
question was "When an important event is happening or is about to happen, many 
people try to get informed about the development of the situation. In such 
situations, where do you get your information from?" On the previous page,
participants are asked to respond to this question by saying "TikTok"
- `age` - numeric, participant's reported age in years
- `gender` - character, participant's self-reported gender identity
- `gender_text` - character, text inputted if "Prefer to self-describe" chosen
for gender identity question
- `political_ideology` - numeric, 1-7 Likert, response to the question "In 
political matters, people talk of 'the left' and 'the right'. Generally
speaking, how would you place your views on this scale?" ranging from Left (1) 
to Neutral (4) to Right (7)
- `religiosity` - numeric, 1-7 Likert, response to the question "How religious
are you?" ranging from Not At All Religious (1) to Somewhat Religious (4) to
Very Religious (7)
- `order` - numeric, 1-2, the order in which the two blocks were presented
- `dilemma` - character, randomly counterbalanced moral dilemma, Bike or Baby
- `advisor` - character, randomly counterbalanced advisor name, Dr. Smith or
Dr. Thompson for participants in the human condition, ETHIC-AI or INTELLI-MORAL
for participants in the AI condition
- `advice` - character, randomly counterbalanced advice type, Utilitarian or 
Deontological
- `trustworthy` - numeric, 1-7 Likert, response to the question "How trustworthy
do you think [advisor] is?" ranging from Not At All Trustworthy (1) to Extremely
Trustworthy (7)
- `blame` - numeric, 1-7 Likert, response to the question "How much would you 
blame someone if they followed [advisor]'s recommendation?" ranging from Not At
All (1) to Very Much (7)
- `trust_other_issues` - numeric, 1-7 Likert, response to the question "Based on
their advice, how willing would you be to trust [advisor] on other issues?"
ranging from Not At All Willing (1) to Extremely Willing (7)
- `surprise` - numeric, 1-7 Likert, response to the question "How surprised were
you at [advisor]'s recommendation?" ranging from Not At All Surprised (1) to
Extremely Surprised (7)
- `humanlike` - numeric, 1-7 Likert, response to the question "How well do each
of the following words describe [advisor]?" ranging from Machine-like (1) to
Human-like (7), only asked for participants in the AI condition
- `cold` - numeric, 1-7 Likert, response to the question "How well do each of 
the following words describe [advisor]?" ranging from Warm (1) to Cold (7), only
asked for participants in the AI condition
- `illogical` - numeric, 1-7 Likert, response to the question "How well do each
of the following words describe [advisor]?" ranging from Rational (1) to
Illogical (7), only asked for participants in the AI condition
- `judgement_pre` - numeric, 0-1 slider, participants' own moral judgement on 
the dilemma BEFORE seeing advice, with 0 representing a fully deontological
judgement and 1 representing a fully utilitarian judgement
- `judgement_post` - numeric, 0-1 slider, participants' own moral judgement on
the dilemma AFTER seeing advice, with 0 representing a fully deontological
judgement and 1 representing a fully utilitarian judgement
- `confidence_pre` - numeric, 1-7 Likert, participants' confidence in their own
judgement BEFORE seeing advice, response to the question "How confident are you
in your decision?" ranging from Not At All Confident (1) to Extremely Confident (7)
- `confidence_post` - numeric, 1-7 Likert, participants' confidence in their own
judgement AFTER seeing advice, response to the question "How confident are you
in your decision?" ranging from Not At All Confident (1) to Extremely Confident (7)
- `manipulation_check` - character, response to manipulation check question
asked at the end of each block, the question was "You just read a dilemma and 
then saw advice from [advisor]. What did [advisor] recommend in this dilemma?",
either Utilitarian or Deontological depending on the reported direction of the
advice
