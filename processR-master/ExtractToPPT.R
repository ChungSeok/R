require(processR)

labels = list(X="cond", M = "pmi", Y="reaction")
drawModel(labels=labels,box.col="lightcyan")
modelsSummaryTable(labels=labels,data=pmi)
drawModel(labels=labels,data=pmi,whatLabel="est")
