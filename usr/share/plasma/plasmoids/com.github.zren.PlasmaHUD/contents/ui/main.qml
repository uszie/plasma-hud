import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as Plasma
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.taskmanager 0.1 as TaskManager

Item {
    id: mainWidget

    Plasmoid.status: PlasmaCore.Types.HiddenStatus

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: disconnectSource(sourceName)

        function exec(cmd) {
            executable.connectSource(cmd)
        }
    }

    function replacer(key, value) {
        if (key !== "" && typeof (value) === 'object') {
            return value.toString()
        }

        if (typeof (value) === 'string') {
            if (value === '')
                return 'null'
            else if (value.includes(','))
                return value.replace(/,/g, ';')
        }

        return value
    }

    function callDbus(winInfo) {
        var command = 'dbus-send --type=method_call --dest=com.github.zren.PlasmaHUD /PlasmaHUD com.github.zren.PlasmaHUD.setActiveWindow dict:string:string:'
        var jsonString = JSON.stringify(winInfo, replacer, 1).replace(
                    /\": /g, '\",').replace(/\n */g,
                                            '').replace(/^{/,
                                                        '').replace(/}$/, '')
        command = command + jsonString
        executable.exec(command)
    }

    TaskManager.ActivityInfo {
        id: activityInfo
    }

    TaskManager.VirtualDesktopInfo {
        id: virtualDesktopInfo
    }

    TaskManager.TasksModel {
        id: tasksModel
        sortMode: TaskManager.TasksModel.SortVirtualDesktop
        groupMode: TaskManager.TasksModel.GroupDisabled
        activity: activityInfo.currentActivity
        virtualDesktop: virtualDesktopInfo.currentDesktop
        filterByScreen: true //plasmaTasksItem.filterByScreen
        filterByVirtualDesktop: true
        filterByActivity: true
    }

    Repeater {
        id: tasksRepeater
        model: DelegateModel {
            model: tasksModel
            delegate: Item {
                id: task

                readonly property string title: display
                readonly property variant winId: WinIdList[0]
                readonly property int appPid: AppPid
                readonly property string appName: AppName
                readonly property string genericName: GenericName
                readonly property bool isActive: IsActive
                readonly property int stackingOrder: StackingOrder
                readonly property string applicationMenuServiceName: ApplicationMenuServiceName
                readonly property string applicationMenuObjectPath: ApplicationMenuObjectPath

                onIsActiveChanged: {
                    if (isActive) {
                        var winInfo = {
                            "winId": winId,
                            "title": title,
                            "appPid": appPid,
                            "appName": appName,
                            "genericName": genericName,
                            "applicationMenuServiceName": applicationMenuServiceName,
                            "applicationMenuObjectPath": applicationMenuObjectPath
                        }

                        callDbus(winInfo)
                    }
                }
            }
        }
    }
}
