############################
## ab_testing with Python ##
############################

#import packages
import os
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np
import seaborn as sns
from scipy import stats

#set wd
cwd = os.getcwd()
print(cwd)
os.chdir('C:\\workspacePython\\ab_testing_py')

#load df
df = pd.read_csv("ab_data.csv")
df.head()
df.info()

#count NaN in df (rows and columns)
df.isnull().sum().sum()

#drop duplicate rows
df.drop_duplicates(['user_id'], keep='last')

#frequency counts
df['group'].value_counts()
df['landing_page'].value_counts()
df['converted'].value_counts()

#subset group and landing_page, then count frequency of conditions
conditions = df[df.columns[2:4]]
conditions.groupby(["group", "landing_page"]).size()

#remove rows with control+new_page and treatment+old_page
dfclean1 = df[(df.group == "control") & (df.landing_page == "old_page")]
dfclean2 = df[(df.group == "treatment") & (df.landing_page == "new_page")]
dfclean = pd.concat([dfclean1, dfclean2])

#contingency table
contingency_table = pd.crosstab(
    dfclean['group'],
    dfclean['landing_page'],
    margins = True
)
contingency_table

#plot contingency table
control_count = contingency_table.iloc[0][0:2].values
treatment_count = contingency_table.iloc[1][0:2].values

fig = plt.figure(figsize=(10,7))
sns.set(font_scale=1.8)
landing_pages = ["new_page", "old_page"]
p1 = plt.bar(landing_pages, control_count, 0.55, color='#d62728')
p2 = plt.bar(landing_pages, treatment_count, 0.55, bottom=control_count)
plt.legend((p2[0], p1[0]), ('control', 'treatment'))
plt.xlabel('landing pages')
plt.ylabel('count')
plt.show()

#chi-squared test for independence
new = dfclean[['group','converted']].copy()
new_size = new.groupby(["group","converted"]).size()
new_size

new_data = [[127785, 17489], [128047, 17264]]
new_df = pd.DataFrame(new_data, columns = ['no_convert', 'convert'])

f_obs = np.array([new_df.iloc[0][0:2].values, new_df.iloc[1][0:2].values])
f_obs

stats.chi2_contingency(f_obs)[0:3]

