import Quickshell
import "windows"
import "services"
import "overview/modules/overview"

ShellRoot {
    StatusWatcher {}
    WorkspaceService {}
    KeyboardService {}

    IslandIPC {}

    IslandWindow {}

    Overview {}
}