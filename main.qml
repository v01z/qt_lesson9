import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtQuick.Controls 1.4 //for calendar
import ru.geekbrains 1.0

Window {
    width: calendar.width + frameList.width + 30
    height: calendar.height + frameButtons.height + buttonClose.height + 30
    visible: true
    title: qsTr("qt_9")
    Frame{
        id: frameMain
        anchors.fill: parent

        Calendar{
            id: calendar
            onClicked: {
                labelDate.text = Qt.formatDate(calendar.selectedDate, "dd.MM.yyyy")

                listView.model.list.updateCurrentItems(calendar.selectedDate)
                listView.model.list = tasksList

            }
        }
        Label {
            id: labelDate
            anchors.left: calendar.right
            anchors.leftMargin: 10
            anchors.topMargin: 10
            text: Qt.formatDate(new Date(), "dd.MM.yyyy")
        }

        Frame{
            id: frameList
            anchors.left: calendar.right
            anchors.top: labelDate.bottom
            anchors.topMargin: 5
            anchors.leftMargin: 10

            ListView{
                id: listView
                implicitWidth: 270
                implicitHeight: 200
                clip: true

                model: TasksModel {
                    list: tasksList
                }

                delegate: RowLayout{
                    width: listView.width

                    CheckBox{
                        checked: model.done
                        onClicked: model.done = checked
                    }
                    TextField{
                        id: textFieldDescr
                        text: model.description
                        onEditingFinished: model.description = text
                        Layout.fillWidth: true
                    }
                    TextField{
                        id: textFieldDate
                        text: model.date
                        visible: false
                    }
                }
            }
        }
        Frame{
            id: frameButtons
            anchors.top: calendar.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            RowLayout{

                Button{
                    id: btnAdd
                    text: qsTr("Добавить задание")
                    onClicked: tasksList.appendItem(calendar.selectedDate)
                }
                Button {
                    id: btnRemove
                    text: qsTr("Удалить выполненные задания")
                    onClicked: tasksList.removeCompletedItems()
                }
            }
        }
        Button{
            id: buttonClose
            anchors.top: frameButtons.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Покинуть это гостеприимное место")
            onClicked: {
                listView.model.list.writeDataToSQLiteBase()
                close()
            }
        }
    }
}
