# Data README file

**Dataset title:** Clean data from main study for project on "Cross-Cultural
Trust in Artificial Moral Advisors" in long format

**Principal investigator:** Dr. Scott Claessens (scott.claessens@gmail.com)

**Head researcher:** Dr. Jim Everett (j.a.c.everett@kent.ac.uk)

**Institution:** University of Kent

**File format:** CSV file

**File dimensions:** 14192 rows x 28 columns

**Overall number of unique participants**: N = 7096

**Countries:** Brazil, Chile, China, France, Germany, India, Mexico, Poland,
South Africa, Turkey, UK, and USA

**Data collected:** 8th April 2025 -- 3rd May 2025

**Panel aggregator:** Prime Panels 
(https://www.cloudresearch.com/products/prime-panels/)

**Data exclusions:**

To produce this clean dataset, we excluded cases that met any of the following 
criteria:

- Did not finish the survey
- Had a duplicated IP address
- Had a duplicated worker ID
- Sped through the survey in less than 100 seconds
- Sped through the survey in less than 2 MADs below the median duration
- Took more than 24 hours to complete the survey
- Provided a meaningless or gibberish response to the open-ended debrief 
question
- Straightlined by providing the exact same response to all Likert questions on 
both advice pages
- Had more than 50% missing data overall

Note that we retained participants that failed the comprehension checks in this 
clean dataset, so that the data could be analysed with and without comprehension
failures.

**Columns in the dataset:**

- `id` - numeric, participant identification number
- `country` - character, country the participant currently lives in
- `language` - character, Qualtrics code for the language that the participant
completed the survey in, see here for more details: 
https://www.qualtrics.com/support/survey-platform/survey-module/survey-tools/translate-survey/#AvailableLanguageCodes
- `treatment` - character, randomly assigned treatment
- `age` - numeric, participant's reported age in years
- `gender` - character, participant's self-reported gender identity
- `gender_text` - character, text inputted if "Prefer to self-describe" chosen
for gender identity question
- `education` - numeric, 1-8, response to the question "What is the highest 
level of education you have completed?": (1) some primary school, (2) completed 
primary school, (3) some secondary school, (4) completed secondary school, (5) 
some university, (6) completed university, (7) some advanced study beyond 
university, (8) advanced degree beyond university
- `political_ideology` - numeric, 1-7 Likert, response to the question "In 
political matters, people talk of 'the left' and 'the right'. Generally
speaking, how would you place your views on this scale?" ranging from Left (1) 
to Neutral (4) to Right (7) - question not asked in China
- `religiosity` - numeric, 1-7 Likert, response to the question "How religious
are you?" ranging from Not At All Religious (1) to Somewhat Religious (4) to
Very Religious (7)
- `subjective_SES` - numeric, 1-10, response to the MacArthur Scale of 
Subjective Social Status, where 1 is the lowest rung on the ladder and 10 is the
highest rung on the ladder
- `AI_familiarity` - numeric, 1-7, response to the question "How familiar are 
you with AI tools like ChatGPT?" ranging from Extremely Unfamiliar (1) to
Extremely Familiar (7)
- `AI_frequency` - numeric, 1-5, response to the question "How frequently do you
use AI tools like ChatGPT?" with the following possible responses: (1) Never, (2) 
Rarely, (3) Occasionally, (4) Frequently, and (5) Very Frequently
- `AI_trustworthy` - numeric, 1-7, response to the question "How trustworthy do
you think AI tools like ChatGPT are?" ranging from Extremely Untrustworthy (1)
to Extremely Trustworthy (7)
- `order` - numeric, 1-2, the order in which the two blocks were presented
- `dilemma` - character, randomly counterbalanced moral dilemma, Bike or Baby
- `advisor` - character, randomly counterbalanced advisor name, Dr. Smith or
Dr. Thompson for participants in the human condition, ETHIC-AI or VIRTUE-BOT for
participants in the AI condition
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
Human-like (7)
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
- `comprehension_check` - character, whether the participant correctly answered
the comprehension check question asked at the end of each block. The question 
was "You just read a dilemma and then saw advice from [advisor]. What did 
[advisor] recommend in this dilemma?" The correct answer was either Utilitarian
or Deontological depending on the reported direction of the advice
