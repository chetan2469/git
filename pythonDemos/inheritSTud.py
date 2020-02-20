class Studententry():
    def __init__(self):
        self.num = int(input("Enter No. of student"))
        self.stud = []

    def dataentry(self):
        for i in range(self.num):
            self.r = int(input("Enter Roll No. of student : "))
            self.m1 = int(input("Enter mark one : "))
            self.m2 = int(input("Enter mark two : "))

            self.studdata = {"r": self.r, "m1": self.m1, "m2": self.m2,"t":0,"p":0}
            self.stud.append(self.studdata)


class Calculations(Studententry):
    def maketotals(self,m1,m2):
        return m1+m2

class CalcAverage:
    def percentit(self, total):
        return (total) / 2


class PrintServices(Calculations, CalcAverage):
    def updatestud(self):
        for i in self.stud:
            i["t"]=self.maketotals(i["m1"],i["m2"])
            i["p"]=self.percentit(i["t"])
    def printit(self):
        for i in self.stud:
            print(i)

p=PrintServices()
p.dataentry()
p.updatestud()
p.printit()