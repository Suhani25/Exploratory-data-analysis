import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df1=pd.read_csv(r'C:\Users\kapoo\Downloads\student_attendance1.csv',parse_dates=True,sep=';',header=None)
df1.columns=['id', 'faculty_id', 'paper_id', 'slot_id', 'student_id','is_present', 'attendance_date', 'attendance_type', 'created_on',"class_time"]
df1.attendance_date[df1.attendance_date=="17 August, 2017"]="17 Aug, 2017"

df1.head()
df1.info()
df1.describe()

df1["day_of_week"]=pd.to_datetime(df1["attendance_date"],format="%d %b, %Y").dt.weekday_name
df1.head()
df1["day_of_week"]

a=pd.crosstab(df1.paper_id,df1.is_present).apply(lambda x:(x*100/x.sum()),axis=1).reset_index()
print(a)



b=pd.crosstab(df1.day_of_week,df1.is_present).apply(lambda x:(x*100/x.sum()),axis=1).reset_index()
print(b)


import plotly
import plotly.graph_objs as go
import plotly.plotly as py


trace1=go.Bar(x=b["day_of_week"],y=b["A"],name="% absent")
trace2=go.Bar(x=b["day_of_week"],y=b["P"],name="% present")
data=[trace1,trace2]
layout=go.Layout(barmode="group",title="% ABSENT-PRESENT ON A WEEKDAY",xaxis=dict(title="WeekDay"),yaxis=dict(title="% attendance",range=[0,100]))
fig=go.Figure(data,layout)
plotly.offline.plot(fig)

c=pd.crosstab(df1.class_time,df1.is_present).apply(lambda x:(x*100/x.sum()),axis=1).reset_index()
print(c)
trace3=go.Bar(x=c["class_time"],y=c["A"],name="% absent")
trace4=go.Bar(x=c["class_time"],y=c["P"],name="% present")
data1=[trace3,trace4]
layout1=go.Layout(barmode="group",title="% ABSENT-PRESENT in different class time",xaxis=dict(title="Class time"),yaxis=dict(title="% attendance",range=[0,100]))
fig1=go.Figure(data1,layout1)
plotly.offline.plot(fig1)




#to calculate % absent-present in different slots for all faculty id
f1=pd.crosstab([df1.faculty_id,df1.slot_id],df1.is_present).apply(lambda x:(x*100/x.sum()),axis=1).reset_index()
f1







#to calculate % absent-present in different slots for all student id
f2=pd.crosstab([df1.student_id,df1.slot_id],df1.is_present).apply(lambda x:(x*100/x.sum()),axis=1).reset_index()
f2


#another way to calculate % absent-present in different slots for all student id
f3=pd.crosstab(df1.student_id,[df1.slot_id,df1.is_present]).reset_index()

#to calculate % absent-present in different papers for all student id
f4=pd.crosstab(df1.student_id,[df1.paper_id,df1.is_present]).reset_index()


#another way to calculate % absent-present in different papers for all
student id
f5=pd.crosstab([df1.student_id,df1.paper_id],df1.is_present).apply(lambda x:(x*100/x.sum()),axis=1).reset_index()
