extends Control

var lang := "pt"
var stage := 0
var hp := 30
var enemy_hp := 18
var faith := 10
var log_label: Label
var stats_label: Label
var choices: HBoxContainer
var title_label: Label

const WORDS = {
 "pt": ["BÍBLIA SAGRADA — CHRONICLES OF FAITH", "No princípio, Deus criou os céus e a terra.", "A luz foi criada. E Deus viu que era boa.", "Adão e Eva vivem no jardim do Éden.", "Caim e Abel oferecem seus dons.", "Noé recebe a missão de construir a arca.", "Um animal selvagem bloqueia o caminho!", "Vitória! A jornada da fé continua.", "Ataque", "Oração", "Continuar", "Português", "Inglês", "Espanhol"],
 "en": ["HOLY BIBLE — CHRONICLES OF FAITH", "In the beginning God created heaven and earth.", "Light was created. And God saw that it was good.", "Adam and Eve live in the Garden of Eden.", "Cain and Abel bring their offerings.", "Noah is called to build the ark.", "A wild animal blocks the path!", "Victory! The journey of faith continues.", "Attack", "Prayer", "Continue", "Portuguese", "English", "Spanish"],
 "es": ["BIBLIA SAGRADA — CHRONICLES OF FAITH", "En el principio Dios creó el cielo y la tierra.", "La luz fue creada. Y Dios vio que era buena.", "Adán y Eva viven en el jardín del Edén.", "Caín y Abel presentan sus ofrendas.", "Noé recibe la misión de construir el arca.", "¡Un animal salvaje bloquea el camino!", "¡Victoria! Continúa el camino de la fe.", "Atacar", "Oración", "Continuar", "Portugués", "Inglés", "Español"]
}

func _ready() -> void:
 var bg := ColorRect.new()
 bg.color = Color("#142b35")
 bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(bg)
 var layout := VBoxContainer.new()
 layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 layout.add_theme_constant_override("separation", 20)
 add_child(layout)
 title_label = Label.new()
 title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 title_label.add_theme_font_size_override("font_size", 23)
 layout.add_child(title_label)
 var spacer := Control.new()
 spacer.custom_minimum_size.y = 45
 layout.add_child(spacer)
 log_label = Label.new()
 log_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 log_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 log_label.add_theme_font_size_override("font_size", 19)
 layout.add_child(log_label)
 stats_label = Label.new()
 stats_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 layout.add_child(stats_label)
 choices = HBoxContainer.new()
 choices.alignment = BoxContainer.ALIGNMENT_CENTER
 layout.add_child(choices)
 var credit := Label.new()
 credit.text = "by Raoni Claro"
 credit.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 layout.add_child(credit)
 _render()

func _button(label: String, callback: Callable) -> void:
 var b := Button.new()
 b.text = label
 b.custom_minimum_size = Vector2(130, 50)
 choices.add_child(b)
 b.pressed.connect(callback)

func _choose_language(code: String) -> void:
 lang = code
 stage = 0
 _render()

func _next() -> void:
 stage += 1
 _render()

func _attack() -> void:
 enemy_hp -= 7
 if enemy_hp > 0:
  hp -= 4
 else:
  stage = 7
 _render()

func _pray() -> void:
 faith += 3
 hp = min(30, hp + 5)
 enemy_hp -= 3
 if enemy_hp <= 0:
  stage = 7
 _render()

func _render() -> void:
 for child in choices.get_children():
  child.queue_free()
 var w: Array = WORDS[lang]
 title_label.text = w[0]
 if stage == 0:
  log_label.text = w[1]
  _button(w[11], func(): _choose_language("pt"))
  _button(w[12], func(): _choose_language("en"))
  _button(w[13], func(): _choose_language("es"))
  _button(w[10], _next)
 elif stage < 6:
  log_label.text = w[stage]
  _button(w[10], _next)
 elif stage == 6:
  log_label.text = w[6]
  _button(w[8], _attack)
  _button(w[9], _pray)
 else:
  log_label.text = w[7]
  _button(w[10], func(): stage = 0; hp = 30; enemy_hp = 18; _render())
 stats_label.text = "HP: %d  |  Faith: %d  |  Enemy: %d" % [hp, faith, max(0, enemy_hp)] if stage == 6 else ""
