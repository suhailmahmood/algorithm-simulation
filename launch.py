from PyQt5.QtCore import QObject, QUrl
from PyQt5.Qt import QApplication, QQmlApplicationEngine


if __name__=='__main__':
    import os
    import sys

class Main(QObject):
    def __init__(self,parent=None):
        super().__init__(parent)
        self.engine = QQmlApplicationEngine(self)
        self.engine.load(QUrl.fromLocalFile('application.qml'))
        self.window = self.engine.rootObjects()[0]

    def show(self):
        self.window.show()

app=QApplication(sys.argv)
main=Main()
main.show()
sys.exit(app.exec_())
