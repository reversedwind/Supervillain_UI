--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = SVUI;
local L = LibStub("LibSuperVillain-1.0"):Lang();
local gameLocale = GetLocale()
if gameLocale == "enUS" then
	L["AURAS_DESC"] = "Configure the aura icons that appear near the minimap."
	L["BAGS_DESC"] = "Adjust bag settings for SVUI."
	L["CHAT_DESC"] = "Adjust chat settings for SVUI."
	L["STATS_DESC"] = "Configure docked stat panels."
	L["SVUI_DESC"] = "SVUI is a complete User Interface replacement addon for World of Warcraft."
	L["NAMEPLATE_DESC"] = "Modify the nameplate settings."
	L["PANEL_DESC"] = "Adjust the size of your left and right panels, this will effect your chat and bags."
	L["ART_DESC"] = "Enable / Disable Window Modifications."
	L["TOGGLEART_DESC"] = "Enable / Disable this change."
	L["TOOLTIP_DESC"] = "Setup options for the Tooltip."
	L["TEXT_FORMAT_DESC"] = "Select the formatting of this text"
	L["import"] = "Existing Profiles"
	L["import_desc"] = "You can either create a new profile by entering a name in the editbox, or choose one of the already existing profiles."
	L["import_sub"] = "Select one of your currently available profiles."
	L["import"] = "Copy From"
	L["copy_desc"] = "Copy the settings from one existing profile into the currently active profile."
	L["current"] = "Current Profile:"
	L["default"] = "Default"
	L["delete"] = "Delete a Profile"
	L["delete_confirm"] = "Are you sure you want to delete the selected profile?"
	L["delete_desc"] = "Delete existing and unused profiles from the database to save space, and cleanup the SavedVariables file."
	L["delete_sub"] = "Deletes a profile from the database."
	L["intro"] = "You can change the active database profile, so you can have different settings for every character."
	L["export"] = "New"
	L["export_sub"] = "Create a new empty profile."
	L["profiles"] = "Profiles"
	L["profiles_sub"] = "Manage Profiles"
	L["reset"] = "Reset Profile"
	L["reset_desc"] = "Reset the current profile back to its default values, in case your configuration is broken, or you simply want to start over."
	L["reset_sub"] = "Reset the current profile to the default"
	L["BottomRightDataPanel"] = "Bottom Bar Right"
	L["BottomLeftDataPanel"] = "Bottom Bar Left"
	L["TopLeftDataPanel"] = "Top Bar Left"
	L["TopRightDataPanel"] = "Top Bar Right"
end
if gameLocale == "frFR" then
	L["AURAS_DESC"] = "Configure les icônes qui apparaissent près de la Minicarte."
	L["BAGS_DESC"] = "Ajuster les paramètres des sacs pour SVUI."
	L["CHAT_DESC"] = "Ajuste les paramètres du Chat pour SVUI."
	L["STATS_DESC"] = "Configure docked stat panels.";
	L["SVUI_DESC"] = "SVUI est une interface de remplacement complète pour World of Warcraft"
	L["NAMEPLATE_DESC"] = "Modifier la configuration des noms d'unités"
	L["PANEL_DESC"] = "Ajuste la largeur et la hauteur des fenêtres de chat, cela ajuste aussi les sacs."
	L["ART_DESC"] = "Ajuste les paramètres d'habillage."
	L["TOGGLEART_DESC"] = "Active ou désactive l'habillage SVUI des éléments ci-dessous."
	L["TOOLTIP_DESC"] = "Configuration des Info-bulles."
	L["TEXT_FORMAT_DESC"] = "Select the formatting of this text"
	L["import"] = "Profils existants"
	L["import_desc"] = "Vous pouvez créer un nouveau profil en entrant un nouveau nom dans la boîte de saisie, ou en choississant un des profils déjà existants."
	L["import_sub"] = "Permet de choisir un des profils déjà disponibles."
	L["import"] = "Copier à partir de"
	L["copy_desc"] = "Copie les paramètres d'un profil déjà existant dans le profil actuellement actif."
	L["current"] = "Current Profile:"
	L["default"] = "Défaut"
	L["delete"] = "Supprimer un profil"
	L["delete_confirm"] = "Etes-vous sûr de vouloir supprimer le profil sélectionné ?"
	L["delete_desc"] = "Supprime les profils existants inutilisés de la base de données afin de gagner de la place et de nettoyer le fichier SavedVariables."
	L["delete_sub"] = "Supprime un profil de la base de données."
	L["intro"] = "Vous pouvez changer le profil actuel afin d'avoir des paramètres différents pour chaque personnage, permettant ainsi d'avoir une configuration très flexible."
	L["export"] = "Nouveau"
	L["export_sub"] = "Créée un nouveau profil vierge."
	L["profiles"] = "Profils"
	L["profiles_sub"] = "Gestion des profils"
	L["reset"] = "Réinitialiser le profil"
	L["reset_desc"] = "Réinitialise le profil actuel au cas où votre configuration est corrompue ou si vous voulez tout simplement faire table rase."
	L["reset_sub"] = "Réinitialise le profil actuel avec les paramètres par défaut."
	L["BottomRightDataPanel"] = "Bottom Bar Right"
	L["BottomLeftDataPanel"] = "Bottom Bar Left"
	L["TopLeftDataPanel"] = "Top Bar Left"
	L["TopRightDataPanel"] = "Top Bar Right"
end
if gameLocale == "deDE" then
	L["AURAS_DESC"] = "Konfiguriere die Symbole für die Stärkungs- und Schwächungszauber nahe der Minimap."
	L["BAGS_DESC"] = "Konfiguriere die Einstellungen für die Taschen."
	L["CHAT_DESC"] = "Anpassen der Chateinstellungen für SVUI."
	L["STATS_DESC"] = "Configure docked stat panels.";
	L["SVUI_DESC"] = "SVUI ist ein komplettes Benutzerinterface für World of Warcraft."
	L["NAMEPLATE_DESC"] = "Konfiguriere die Einstellungen für die Namensplaketten."
	L["PANEL_DESC"] = "Stellt die Größe der linken und rechten Leisten ein, dies hat auch Einfluss auf den Chat und die Taschen."
	L["ART_DESC"] = "Passe die Einstellungen für externe Addon PrestoChange / Optionen an."
	L["TOGGLEART_DESC"] = "Aktiviere / Deaktiviere diesen Style."
	L["TOOLTIP_DESC"] = "Konfiguriere die Einstellungen für Tooltips."
	L["TEXT_FORMAT_DESC"] = "Select the formatting of this text"
	L["import"] = "Vorhandene Profile"
	L["import_desc"] = "Du kannst ein neues Profil erstellen, indem du einen neuen Namen in der Eingabebox 'Neu' eingibst, oder wähle eines der vorhandenen Profile aus."
	L["import_sub"] = "Wählt ein bereits vorhandenes Profil aus."
	L["import"] = "Kopieren von..."
	L["copy_desc"] = "Kopiere die Einstellungen von einem vorhandenen Profil in das aktive Profil."
	L["default"] = "Standard"
	L["delete"] = "Profil löschen"
	L["delete_confirm"] = "Willst du das ausgewählte Profil wirklich löschen?"
	L["delete_desc"] = "Lösche vorhandene oder unbenutzte Profile aus der Datenbank um Platz zu sparen und um die SavedVariables Datei 'sauber' zu halten."
	L["delete_sub"] = "Löscht ein Profil aus der Datenbank."
	L["intro"] = "Hier kannst du das aktive Datenbankprofile ändern, damit du verschiedene Einstellungen für jeden Charakter erstellen kannst, wodurch eine sehr flexible Konfiguration möglich wird."
	L["export"] = "Neu"
	L["export_sub"] = "Ein neues Profil erstellen."
	L["profiles"] = "Profile"
	L["profiles_sub"] = "Profile verwalten"
	L["reset"] = "Profil zurücksetzen"
	L["reset_desc"] = "Setzt das momentane Profil auf Standardwerte zurück, für den Fall das mit der Konfiguration etwas schief lief oder weil du einfach neu starten willst."
	L["reset_sub"] = "Das aktuelle Profil auf Standard zurücksetzen."
	L["BottomRightDataPanel"] = "Bottom Bar Right"
	L["BottomLeftDataPanel"] = "Bottom Bar Left"
	L["TopLeftDataPanel"] = "Top Bar Left"
	L["TopRightDataPanel"] = "Top Bar Right"
end
if gameLocale == "itIT" then
	L["AURAS_DESC"] = "Configure the aura icons that appear near the minimap."
	L["BAGS_DESC"] = "Adjust bag settings for SVUI."
	L["CHAT_DESC"] = "Adjust chat settings for SVUI."
	L["STATS_DESC"] = "Configure docked stat panels.";
	L["SVUI_DESC"] = "SVUI is a complete User Interface replacement addon for World of Warcraft."
	L["NAMEPLATE_DESC"] = "Modify the nameplate settings."
	L["PANEL_DESC"] = "Adjust the size of your left and right panels, this will effect your chat and bags."
	L["ART_DESC"] = "Adjust Style settings."
	L["TOGGLEART_DESC"] = "Enable / Disable this style."
	L["TOOLTIP_DESC"] = "Setup options for the Tooltip."
	L["TEXT_FORMAT_DESC"] = "Select the formatting of this text"
	L["import"] = "Profili esistenti"
	L["import_desc"] = "Puoi creare un nuovo profilo digitando il nome della casella di testo, oppure scegliendone uno tra i profili gia' esistenti."
	L["import_sub"] = "Seleziona uno dei profili disponibili."
	L["import"] = "Copia Da"
	L["copy_desc"] = "Copia le impostazioni da un profilo esistente, nel profilo attivo in questo momento."
	L["current"] = "Profilo Attivo:"
	L["default"] = "Standard"
	L["delete"] = "Cancella un profilo"
	L["delete_confirm"] = "Sei sicuro di voler cancellare il profilo selezionato?"
	L["delete_desc"] = "Cancella i profili non utilizzati dal database per risparmiare spazio e mantenere puliti i file di configurazione SavedVariables."
	L["delete_sub"] = "Cancella un profilo dal Database."
	L["intro"] = "Puoi cambiare il profilo attivo, in modo da usare impostazioni diverse per ogni personaggio."
	L["export"] = "Nuovo"
	L["export_sub"] = "Crea un nuovo profilo vuoto."
	L["profiles"] = "Profili"
	L["profiles_sub"] = "Gestisci Profili"
	L["reset"] = "Reimposta Profilo"
	L["reset_desc"] = "Riporta il tuo profilo attivo alle sue impostazioni di default, nel caso in cui la tua configurazione si sia corrotta, o semplicemente tu voglia re-inizializzarla."
	L["reset_sub"] = "Reimposta il profilo ai suoi valori di default."
	L["BottomRightDataPanel"] = "Bottom Bar Right"
	L["BottomLeftDataPanel"] = "Bottom Bar Left"
	L["TopLeftDataPanel"] = "Top Bar Left"
	L["TopRightDataPanel"] = "Top Bar Right"
end
if gameLocale == "koKR" then
	L["AURAS_DESC"] = "Configure the aura icons that appear near the minimap."
	L["BAGS_DESC"] = "SVUI 위해 가방 설정을 조정합니다."
	L["CHAT_DESC"] = "SVUI의 대화창을 설정합니다."
	L["STATS_DESC"] = "Configure docked stat panels.";
	L["SVUI_DESC"] = "SVUI는 WoW의 애드온을 대신하는 완전한 애드온입니다."
	L["NAMEPLATE_DESC"] = "이름표의 설정을 수정합니다."
	L["PANEL_DESC"] = "좌우 패널의 너비를 조절합니다. 이 값에 따라 대화창과 가방의 크기가 변경됩니다."
	L["ART_DESC"] = "애드온이나 프레임의 스킨을 설정합니다."
	L["TOGGLEART_DESC"] = "스킨 사용 / 중지"
	L["TOOLTIP_DESC"] = "툴팁을 설정합니다."
	L["TEXT_FORMAT_DESC"] = "Select the formatting of this text"
	L["import"] = "프로필 선택"
	L["import_desc"] = "새로운 이름을 입력하거나, 이미 있는 프로필중 하나를 선택하여 새로운 프로필을 만들 수 있습니다."
	L["import_sub"] = "당신이 현재 이용할수 있는 프로필을 선택합니다."
	L["import"] = "복사"
	L["copy_desc"] = "현재 사용중인 프로필에, 선택한 프로필의 설정을 복사합니다."
	L["current"] = "Current Profile:"
	L["default"] = "기본값"
	L["delete"] = "프로필 삭제"
	L["delete_confirm"] = "정말로 선택한 프로필의 삭제를 원하십니까?"
	L["delete_desc"] = "데이터베이스에 사용중이거나 저장된 프로파일 삭제로 SavedVariables 파일의 정리와 공간 절약이 됩니다."
	L["delete_sub"] = "데이터베이스의 프로필을 삭제합니다."
	L["intro"] = "모든 캐릭터의 다양한 설정과 사용중인 데이터베이스 프로필, 어느것이던지 매우 다루기 쉽게 바꿀수 있습니다."
	L["export"] = "새로운 프로필"
	L["export_sub"] = "새로운 프로필을 만듭니다."
	L["profiles"] = "프로필"
	L["profiles_sub"] = "프로필 설정"
	L["reset"] = "프로필 초기화"
	L["reset_desc"] = "단순히 다시 새롭게 구성을 원하는 경우, 현재 프로필을 기본값으로 초기화 합니다."
	L["reset_sub"] = "현재의 프로필을 기본값으로 초기화 합니다"
	L["BottomRightDataPanel"] = "Bottom Bar Right"
	L["BottomLeftDataPanel"] = "Bottom Bar Left"
	L["TopLeftDataPanel"] = "Top Bar Left"
	L["TopRightDataPanel"] = "Top Bar Right"
end
if gameLocale == "ptBR" then
	L["AURAS_DESC"] = "Configurar os ícones das auras que aparecem perto do minimapa."
	L["BAGS_DESC"] = "Ajustar definições das bolsas para a SVUI."
	L["CHAT_DESC"] = "Adjustar definições do bate-papo para o SVUI."
	L["STATS_DESC"] = "Configure docked stat panels.";
	L["SVUI_DESC"] = "A SVUI é um Addon completo de substituição da interface original do World of Warcraft."
	L["NAMEPLATE_DESC"] = "Modificar as definições das Placas de Identificação."
	L["PANEL_DESC"] = "Ajustar o tamanho dos painéis da esquerda e direita, isto irá afetar suas bolsas e bate-papo."
	L["ART_DESC"] = "Ajustar definições de Aparências."
	L["TOGGLEART_DESC"] = "Ativa / Desativa a aparência deste quadro."
	L["TOOLTIP_DESC"] = "Opções de configuração para a Tooltip."
	L["TEXT_FORMAT_DESC"] = "Select the formatting of this text"
	L["BottomRightDataPanel"] = "Bottom Bar Right"
	L["BottomLeftDataPanel"] = "Bottom Bar Left"
	L["TopLeftDataPanel"] = "Top Bar Left"
	L["TopRightDataPanel"] = "Top Bar Right"
end
if gameLocale == "ruRU" then
	L["AURAS_DESC"] = "Настройка иконок эффектов, находящихся у миникарты."
	L["BAGS_DESC"] = "Настройки сумок SVUI"
	L["CHAT_DESC"] = "Настройте отображение чата SVUI."
	L["STATS_DESC"] = "Configure docked stat panels.";
	L["SVUI_DESC"] = "SVUI это аддон для полной замены пользовательского интерфейса World of Warcraft."
	L["NAMEPLATE_DESC"] = "Настройки индикаторов здоровья."
	L["PANEL_DESC"] = "Регулирование размеров левой и правой панелей. Это окажет эффект на чат и сумки."
	L["ART_DESC"] = "Установки скинов"
	L["TOGGLEART_DESC"] = "Включить / выключить этот скин."
	L["TOOLTIP_DESC"] = "Опций подсказки"
	L["TEXT_FORMAT_DESC"] = "Select the formatting of this text"
	L["import"] = "Существующие профили"
	L["import_desc"] = "Вы можете создать новый профиль, введя название в поле ввода, или выбрать один из уже существующих профилей."
	L["import_sub"] = "Выбор одиного из уже доступных профилей"
	L["import"] = "Скопировать из"
	L["copy_desc"] = "Скопировать настройки из выбранного профиля в активный."
	L["current"] = "            "
	L["default"] = "По умолчанию"
	L["delete"] = "Удалить профиль"
	L["delete_confirm"] = "Вы уверены, что вы хотите удалить выбранный профиль?"
	L["delete_desc"] = "Удалить существующий и неиспользуемый профиль из БД для сохранения места, и очистить SavedVariables файл."
	L["delete_sub"] = "Удаление профиля из БД"
	L["intro"] = "Изменяя активный профиль, вы можете задать различные настройки модификаций для каждого персонажа."
	L["export"] = "Новый"
	L["export_sub"] = "Создать новый чистый профиль"
	L["profiles"] = "Профили"
	L["profiles_sub"] = "Управление профилями"
	L["reset"] = "Сброс профиля"
	L["reset_desc"] = "Если ваша конфигурации испорчена или если вы хотите настроить всё заново - сбросьте текущий профиль на стандартные значения."
	L["reset_sub"] = "Сброс текущего профиля на стандартный"
	L["BottomRightDataPanel"] = "Bottom Bar Right"
	L["BottomLeftDataPanel"] = "Bottom Bar Left"
	L["TopLeftDataPanel"] = "Top Bar Left"
	L["TopRightDataPanel"] = "Top Bar Right"
end
if gameLocale == "esES" or gameLocale == "esMX" then
	L["AURAS_DESC"] = "Configura los iconos de las auras que aparecen cerca del minimapa."
	L["BAGS_DESC"] = "Ajusta las opciones de las bolsas para SVUI."
	L["CHAT_DESC"] = "Configura los ajustes del chat para SVUI."
	L["STATS_DESC"] = "Configure docked stat panels.";
	L["SVUI_DESC"] = "SVUI es un addon que reemplaza la interfaz completa de World of Warcraft."
	L["NAMEPLATE_DESC"] = "Modifica las opciones de la placa de nombre"
	L["PANEL_DESC"] = "Ajusta el tamaño de los paneles izquierdo y derecho. Esto afectará las ventanas de chat y las bolsas."
	L["ART_DESC"] = "Configura los Ajustes de Cubiertas."
	L["TOGGLEART_DESC"] = "Activa / Desactiva esta cubierta."
	L["TOOLTIP_DESC"] = "Configuración para las Descripciones Emergentes."
	L["TEXT_FORMAT_DESC"] = "Select the formatting of this text"
	L["import"] = "Perfiles existentes"
	L["import_desc"] = "Puedes crear un nuevo perfil introduciendo un nombre en el recuadro o puedes seleccionar un perfil de los ya existentes."
	L["import_sub"] = "Selecciona uno de los perfiles disponibles."
	L["import"] = "Copiar de"
	L["copy_desc"] = "Copia los ajustes de un perfil existente al perfil actual."
	L["current"] = "Current Profile:"
	L["default"] = "Por defecto"
	L["delete"] = "Borrar un Perfil"
	L["delete_confirm"] = "¿Estas seguro que quieres borrar el perfil seleccionado?"
	L["delete_desc"] = "Borra los perfiles existentes y sin uso de la base de datos para ganar espacio y limpiar el archivo SavedVariables."
	L["delete_sub"] = "Borra un perfil de la base de datos."
	L["intro"] = "Puedes cambiar el perfil activo de tal manera que cada personaje tenga diferentes configuraciones."
	L["export"] = "Nuevo"
	L["export_sub"] = "Crear un nuevo perfil vacio."
	L["profiles"] = "Perfiles"
	L["profiles_sub"] = "Manejar Perfiles"
	L["reset"] = "Reiniciar Perfil"
	L["reset_desc"] = "Reinicia el perfil actual a los valores por defectos, en caso de que se haya estropeado la configuración o quieras volver a empezar de nuevo."
	L["reset_sub"] = "Reinicar el perfil actual al de por defecto"
	L["BottomRightDataPanel"] = "Bottom Bar Right"
	L["BottomLeftDataPanel"] = "Bottom Bar Left"
	L["TopLeftDataPanel"] = "Top Bar Left"
	L["TopRightDataPanel"] = "Top Bar Right"
end
if gameLocale == "zhTW" then
	L["AURAS_DESC"] = "小地圖旁的光環圖示設定."
	L["BAGS_DESC"] = "調整 SVUI 背包設定."
	L["CHAT_DESC"] = "對話框架設定."
	L["STATS_DESC"] = "Configure docked stat panels.";
	L["SVUI_DESC"] = "SVUI 為一套功能完整, 可用來替換 WOW 原始介面的 UI 套件"
	L["NAMEPLATE_DESC"] = "修改血條設定."
	L["PANEL_DESC"] = "調整左、右對話框的尺寸, 此設定將會影響對話與背包框架的尺寸."
	L["ART_DESC"] = "調整外觀設定."
	L["TOGGLEART_DESC"] = "啟用 / 停用此外觀."
	L["TOOLTIP_DESC"] = "浮動提示資訊設定選項."
	L["TEXT_FORMAT_DESC"] = "Select the formatting of this text"
	L["import"] = "現有的設定檔"
	L["import_desc"] = "你可以通過在文本框內輸入一個名字創立一個新的設定檔，也可以選擇一個已經存在的設定檔。"
	L["import_sub"] = "從當前可用的設定檔裏面選擇一個。"
	L["import"] = "複製自"
	L["copy_desc"] = "從當前某個已保存的設定檔複製到當前正使用的設定檔。"
	L["current"] = "Current Profile:"
	L["default"] = "預設"
	L["delete"] = "刪除一個設定檔"
	L["delete_confirm"] = "你確定要刪除所選擇的設定檔嗎？"
	L["delete_desc"] = "從資料庫裏刪除不再使用的設定檔，以節省空間，並且清理SavedVariables檔。"
	L["delete_sub"] = "從資料庫裏刪除一個設定檔。"
	L["intro"] = "你可以選擇一個活動的資料設定檔，這樣你的每個角色就可以擁有不同的設定值，可以給你的插件設定帶來極大的靈活性。"
	L["export"] = "新建"
	L["export_sub"] = "新建一個空的設定檔。"
	L["profiles"] = "設定檔"
	L["profiles_sub"] = "管理設定檔"
	L["reset"] = "重置設定檔"
	L["reset_desc"] = "將當前的設定檔恢復到它的預設值，用於你的設定檔損壞，或者你只是想重來的情況。"
	L["reset_sub"] = "將當前的設定檔恢復為預設值"
	L["BottomRightDataPanel"] = "Bottom Bar Right"
	L["BottomLeftDataPanel"] = "Bottom Bar Left"
	L["TopLeftDataPanel"] = "Top Bar Left"
	L["TopRightDataPanel"] = "Top Bar Right"
end
if gameLocale == "zhCN" then
	L["AURAS_DESC"] = "小地图旁的光环图标设置."
	L["BAGS_DESC"] = "调整 SVUI 背包设置."
	L["CHAT_DESC"] = "对话框架设定"
	L["STATS_DESC"] = "Configure docked stat panels.";
	L["SVUI_DESC"] = "SVUI 为一套功能完整，可用来替换 WOW 原始介面的套件"
	L["NAMEPLATE_DESC"] = "修改血条设定."
	L["PANEL_DESC"] = "调整左、右对话框的大小，此设定将会影响对话与背包框架的大小."
	L["ART_DESC"] = "调整外观设定."
	L["TOGGLEART_DESC"] = "启用 / 停用此外观."
	L["TOOLTIP_DESC"] = "鼠标提示资讯设定选项."
	L["TEXT_FORMAT_DESC"] = "Select the formatting of this text"
	L["import"] = "现有的配置文件"
	L["import_desc"] = "你可以通过在文本框内输入一个名字创立一个新的配置文件，也可以选择一个已经存在的配置文件。"
	L["import_sub"] = "从当前可用的配置文件里面选择一个。"
	L["import"] = "复制自"
	L["copy_desc"] = "从当前某个已保存的配置文件复制到当前正使用的配置文件。"
	L["current"] = "Current Profile:"
	L["default"] = "默认"
	L["delete"] = "删除一个配置文件"
	L["delete_confirm"] = "你确定要删除所选择的配置文件么？"
	L["delete_desc"] = "从数据库里删除不再使用的配置文件，以节省空间，并且清理SavedVariables文件。"
	L["delete_sub"] = "从数据库里删除一个配置文件。"
	L["intro"] = "你可以选择一个活动的数据配置文件，这样你的每个角色就可以拥有不同的设置值，可以给你的插件配置带来极大的灵活性。"
	L["export"] = "新建"
	L["export_sub"] = "新建一个空的配置文件。"
	L["profiles"] = "配置文件"
	L["profiles_sub"] = "管理配置文件"
	L["reset"] = "重置配置文件"
	L["reset_desc"] = "将当前的配置文件恢复到它的默认值，用于你的配置文件损坏，或者你只是想重来的情况。"
	L["reset_sub"] = "将当前的配置文件恢复为默认值"
	L["BottomRightDataPanel"] = "Bottom Bar Right"
	L["BottomLeftDataPanel"] = "Bottom Bar Left"
	L["TopLeftDataPanel"] = "Top Bar Left"
	L["TopRightDataPanel"] = "Top Bar Right"
end