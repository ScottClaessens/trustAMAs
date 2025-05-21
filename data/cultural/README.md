# Data README file

**Dataset title:** Cultural data for project on "Cross-Cultural Trust in 
Artificial Moral Advisors"

**Principal investigator:** Dr. Scott Claessens (scott.claessens@gmail.com)

**Head researcher:** Dr. Jim Everett (j.a.c.everett@kent.ac.uk)

**Institution:** University of Kent

**File format:** CSV file

**File dimensions:** 12 rows x ... columns

**Columns in the dataset:**

- `country` - character, country
- `ISO` - character, country ISO alpha-2 code
- `GDP_per_capita` - numeric, GDP per capita (current USD) in 2023, accessed
from <https://data.worldbank.org/indicator/NY.GDP.PCAP.CD> on 21-05-2025
- `HDI` - numeric, 0-1, human development index in 2023, accessed from 
<https://hdr.undp.org/data-center/human-development-index#/indicies/HDI> on
21-05-2025, higher means more "developed"
- `gini` - numeric, 0-100, Gini index from between 2014-2022, accessed from 
<https://data.worldbank.org/indicator/SI.POV.GINI> on 21-05-2025, higher means
more economic inequality
- `relational_mobility_latent` - numeric, latent means for relational mobility
adjusting for response styles, data from 2014-2016, accessed from 
<https://www.pnas.org/doi/full/10.1073/pnas.1713191115> on 21-05-2025
- `relational_mobility_raw` - numeric, raw means for relational mobility, data 
from 2014-2016, accessed from
<https://www.pnas.org/doi/full/10.1073/pnas.1713191115> on 21-05-2025
- `tightness` - numeric, cultural tightness scores from 2019, accessed from 
<https://www.nature.com/articles/s41467-021-21602-9>, source data downloaded on
21-05-2025
- `individualism` - numeric, individualism from Hofstede, accessed from
<https://www.nature.com/articles/s41467-021-21602-9>, source data downloaded on
21-05-2025
- `AI_readiness` - numeric, 0-100, government AI readiness index from 2024,
accessed from <https://oxfordinsights.com/ai-readiness/ai-readiness-index/> on
21-05-2025
- `AI_index` - numeric, overall AI index measuring investment, innovation, and 
implementation of AI from 2024, accessed from 
<https://www.tortoisemedia.com/data/global-ai> on 21-05-2025
