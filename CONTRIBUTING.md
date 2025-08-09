# Contributoring

This documentation discusses the important information for contribution.

## A. Project Structure

It would be beneficial and ease collaboration when everyone accept a common convention and project structure.
This section describe the convention of the project structure.

### A.A. Directory Convention

This section discusses the convention for directory in this project.
Table A.A.1 illustrates the conventional directories used in the project.

Table A.A.1: Conventional directories and its description.
| Directory | Description |
| ----- | ----- |
| `/external` | A directory that stores all external project files, one that is not to be importent into Godot. |
| `/exports` | A directory that stores exported Godot distributable files. |
| `/scripts` | A directory that stores small, useful GDScripts that is do not extends from `Node`. |
| `/autoloads` | A directory that stores Godot Autoloads. |
| `/tests` | A directory that stores all the tested challenges and its corresponding local dependencies. |
| `/scenes` | A directory that stores all the main scenes and its corresponding local dependencies that act as the root of the scene tree in the main game loop. |
| `/assets` | A directory that stores all the graphical and audio assets. |
| `/prefabs` | A directory that stores all reusable scenes and its local dependencies that is used across all the main scenes. |

### A.B. Crucial Files

This section discusses the important files and its uses.
The aforementioned important files exclude files that are commonly found in most programming projects and their function is not altered, such as `.gitignore` etc.
Table A.B.1 illustrates the crucial files and its description.

Table A.B.1: Crucial files and its description.
| Files | Description |
| ----- | ----- |
| `/CONTRIBUTEING.md` | The file that you are currently viewing. It holds all the conventions to be abided during contributing. |
| `/README.md` | The main description of the game project. It should contains an overview for game mechanics and design. |
| `/externals/content.hn` | A content idea library file viewed through ["Huanian Game Meta Designer"](https://rechie.itch.io/huanian-game-meta-designer) |

### A.C. Coding Convention

This section discusses the convention for coding.

#### A.C.A. Result Error Handling Policy

For error handling, `Result` class from `res://scripts/result.gd` is used.
It is inspired from `Result` enum from Rust.
It is chosen due to the fact that you could fail fast using `Result.unwrap()` method, while having the versatility to handle it by checking whether it is error through `Result.is_successful()` (or `Result.is_erroneous()`).
Moreover, it can pass error message with it, which is useful for debugging.

#### A.C.B. Property-focused with Updator Policy

Utilizing property is much encouraged.
However, due to reference types such as `Array` and `Object`, an updator is required to maximise its usefulness.
In primitive type, a simple setter could handle all the updating as shown in code A.C.B.1.

Code A.C.B.1: Simple setter for primitive type.

```swift
var prop : int :
    set(p_value):
        # Deinitializing code.
        prop = p_value
        # Updating code.
```

However, in the case of reference types, setter function that consists of updating code is not called after mutating the value as shown in code A.C.B.2.

Code A.C.B.2: Undesired circumstances when updating code in setter is not called when value is changed.

```swift
var list : Array :
    set(p_value):
        # Deinitializing code.
        list = p_value
        # Updating code.

func mutate_list() -> void:
    list.append(1) # Setter will not called.
```

To mitigate this issue, updator function is introduced.
Updator functions follows a naming convention, such as `update_from_<property_name>` as shown in code A.C.B.3.

Code A.C.B.3: Property with updator.

```swift
var list : Array :
    set(p_value):
        # Deinitializing code.
        list = p_value
        update_from_list()

func update_from_list() -> void:
    pass # Updating code.

func mutate_list() -> void:
    list.append(1)
    update_from_list() # Updating code is called.
```

Thus, updator method are mandatory for all the setters when there is a need to do update based on the value.
There is no need to factor out the deinitializing code since there is no case to explicitly call deinitializing code.

#### A.C.C. No-privacy Policy

All class' properties and methods are public; there shouldn't have methods or properties that prefix with underscore (`_`) to mark as private.
This enforces the programmer to always think for the others when writing methods as the methods are public, which is to be used by others.
This implicitly forces the naming to be sane and descriptive.

#### A.C.D. Exported Node Reference Policy

When fetching, always use export variable instead of hard-coding with dollar sign (`$`) or `Node.get_node()`.
Always put the exported node reference variable under `Nodes` export group with `node_` prefix as shown in code A.C.D.1.

Code A.C.D.1: Exported node reference variables.

```swift
@export_group("Nodes", "node_")
@export node_timer : Timer
@export node_label : Label
```

This allows the freedom the swap the node in editor instead of modifying the script.

#### A.C.E. Script-Scene Association Policy

For scripts that are closely associated with a scene root, a static method called `get_packed_scene` should be implemented as shown in Code A.C.E.1.

Code A.C.E.1: `get_packed_scene` static method.

```swift
extends Node
class_name Goat

static func get_packed_scene() -> PackedScene:
    return load("res://path/to/Goat.tscn") as PackedScene
```

This ease the spawning of the given class that is heavily dependent on its corresponding scene.

#### A.C.F. Scripted Signal Connection Policy

This policy is to harmonize No-privacy Policy.
No-privacy Policy states the need for all the method to be public.
However, usually signal handler are private methods.
To mitigate this issue, signal connection can be done in `_ready` with the help of Exported Node Reference Policy as shown in code A.C.F.1.

Code A.C.F.1: Signal connection in script.

```swift
@export_group("Nodes", "node_")
@export node_timer : Timer

func _ready() -> void:
    node_timer.timeout.connect(func():
        pass # Do something.
    )
```

With this, you can also swap the node easily with the exported node references instead of removing and reassigning signals in the editor.

#### A.C.G. Strongly-Type Assertion Policy

All variables should be strongly-typed.
For value with erased type, such as when using `Result`, the value should be casted and asserted as shown in code A.C.G.1.

Code A.C.G.1: value-casting and assertion

```swift

func do_something_to_reference(p_value: Variant) -> void:
    var casted := p_value as Node
    assert(Utility.is_object_valid(casted)) # Assure the reference variable is valid after cast.
    # Do something.

func do_something_to_primitive(p_value: Variant) -> void:
    var casted := p_value as int
    # There is no need for casting to primitive value since it will result an error if it is unable to do so.
    # Do something.

```

#### A.C.H. Object-validation Policy

For some technical reason, `null` value doesn't always mean object is valid.
The value can be invalid if `is_instance_valid()` is false or object is queued for deletion.
Thus, use `Utility.is_object_valid()` from `res://scripts/utility.gd` to test the validity of object as shown in code A.C.H.1.

Code A.C.H.1: `Utility.is_object_valid()` usage.

```swift

func do_something(p_value: Object) -> void:
    if not Utility.is_object_valid(p_value): return
    # Do something.

```

#### A.C.I. Early Return Policy

Early return is encouraged as shown in code A.C.I.1.

Code A.C.I.1: Early return demonstration.

```swift

# This is good.
func have_early_return() -> void:
    if is_some_bad_case(): return
    # Do something.

# This is bad.
func no_early_return() -> void:
    if not is_some_bad_case():
        pass # Do something.
```

## B. Workflow

It would be beneficial to have a well-defined workflow in which contributors are able to follow.
This could ease collaboration as contributors' behaviour can be anticipated.
The workflow consists of 3 stages, idea proposal, idea testing, and finally idea integration.
All of them utilizes Github issues and PR to achieve coordination and documentation.

### B.A. Proposal

This section discusses the process of proposal of game idea.
Proposal is where the creativity flourish as the creative ideas being structured and recorded.
The idea are all stored and maintained in `/externals/content.hn` (see [Crucial Files](#ab-crucial-files) section).

It starts with creating a Github issue.
In the Github issue, state the game idea, a challenge in a level and its corresponding required capabilities.
The game idea should be relevant to the given game mechanics.
It is optional but encouraged to add visuals to facilitate idea sharing.
Please read on the [Game Idea Philosophy](#ca-game-idea-philosophy) section when brainstorming an idea.
Please be open-minded during the proposal as often time the reviewer will give feedbacks.
Please do not get discouraged if the idea is not accepted, sometime it is not because the idea bad, but due to financial and time constraint.
When the idea is accepted, you could create a Github PR to add the idea into the content idea library (`/externals/content.hn`).

### B.B. Testing

This section discusses the process of testing of game idea.
Testing is a stage in which the challenge ideas proposed are tested via prototyping.
It is a way to do documentation for technical stuffs as the testing files are used as libraries and examples,
and test out the interaction between the challenge and required capabilities.

For creating a test for challenge idea, it starts with proposing through creating a Github issue.
In the Github issue, state the game idea, the challenge, that you want to test.
When the proposal is accepted, create a PR that includes all the commit for creating the test.
Create a folder in `/tests` directory (see [Directory Convention](#aa-directory-convention)) with the name relevant to the challenge, then put all the files pertains to the challenge under it.
For challenges in which the required capabilities are yet to be implemented, it could be implemented together with the challenge.
The rationale comes from the fact that to test the capability, you need a challenge to test it.
However, the capabilities would be shared across multiple challenges, and thus not bounded to the `/tests` directory.
Usually, it will utilise `/assets`, `/autoloads`, `/scripts`, and `/prefabs` directory (see [Directory Convention](#aa-directory-convention)).
The result of a successful PR should have a working, isolated scene that demonstrate the challenge and its required capabilities.

### B.C. Integration

This section discusses the process of integrating the challenges into the game.
This is a big move as the result from this stage would probably delivered to the main game.
At this stage, creativity and resourcefulness must be present as it is the time to create a level.

It starts with creating a Github issue.
In the Github issue, states the overall level design to be implemented.
It should include the tested challenges to be utilized and how it is presented to the player.
When the proposal is accepted, create a PR for it and start the level creation.
Create a folder in `/scenes` directory (see [Directory Convention](#aa-directory-convention)) with the name relevant to the level, then put all the files pertains to the level under it.
The result of a successful PR should be playable and accessible level in the main game loop.

## C. Appendix

### C.A. Game Idea Philosophy

Oftentimes, in the process of developing a game, creating content, or making a level is the greatest obstacle, as it dictates the value of each mechanic that you have implemented so far. In so many occurrences, game developers tend to design and implement features head first before thinking about how they will play out in the gameplay that is experienced by the player. This is discouraging when the game features are actually not as useful and fun as it seems when the demo level is created. Sometimes the game feature itself is to blame, but most of the time, the demo level is probably not designed to emphasize the use case of the aforementioned features. When we plan game features in advance of game level, it feels like making a solution without a problem. In the end, the game features, or the capability that is given to the player, are just tools to overcome the puzzle; the puzzle itself is the entity that made up a game. Although the capabilities are important to solve a puzzle, without a puzzle, the capabilities are meaningless.

Designing levels are putting different variations of locks and keys together. Locks in this context are any form of obstacles while keys are any form of solution that overcomes the obstacles. To make the level fun, there must be optimal exposure of discovery of variations of locks and keys. Too much exposure to discovery will cause overwhelm. Imagine when you are just given a big dictionary of foreign language and you are tasked to write a Shakespeare level scripture. You definitely will be overwhelmed; you just don’t know what to do and where to start. Too little exposure to discovery will cause boredom. Now, write your name 100 times (Don’t! Just imagine the task would be enough). There are no new things to discover, just the same stroke again and again. Boring! So, good levels are levels that introduce new problems and corresponding solutions with good pacing.

Do note that fun doesn’t necessarily have locks and keys, just that locks and keys are a really good place to start for making a level. Fun at its core is discovery. This is why discovery and variation are emphasized. You need more variation to have more discovery, which is fun. There is always fun in variations of art and music. However, the fun in pure art and music in game is fleeting; visuals and audios are just super fast to be consumed and achieve complete discovery. We don’t want fleeting fun as it soon becomes boring. So, these are usually auxiliary, such as beautiful background, cool ambient noise, and NPC communication. It is good to have them, but at a requirement that the basis of level design is completed.
