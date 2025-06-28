

# 😼 My dot-files

A curated collection of **Bash scripts** and **dotfiles** used to automate daily tasks, improve productivity, and customize the development environment.

---

## 📁 Repository Structure

- `scripts/` – Standalone Bash scripts, each in its own file with clear comments and usage instructions.
- `dotfiles/` – Personal configuration files for various tools:
  - `wezterm/` – Custom WezTerm terminal configuration.
  - `starship/` – Starship prompt configuration.

The structure is kept simple and modular for easy navigation and customization.

---

## 🔧 Requirements

These scripts are designed to run in a Unix-like environment with Bash. Some may rely on common command-line tools such as:

- `curl`
- `git`

Check the script headers for any additional dependencies or usage notes.

---

## 🚀 Usage

1. Clone the repository:
   ```bash
      git clone https://github.com/mvtt25/my-dotfiles.git
      cd my-dotfiles
   ```
   - Make a script executable:
   ```bash
      chmod +x scripts/script-name.sh
   ```

2. Run the script:
   ```bash
    ./scripts/script-name.sh
   ```
    > ⚠️ Warning: Always review a script before running it to ensure it behaves as expected in your environment.

### 📜 Available Scripts
| Script Name      | Description                            |
| ---------------- | -------------------------------------- |
| `backup_auto.sh` | Creates a backup of specified folders. |
| `tmpcleaner.sh`  | Removes temporary files.               |
| `iplookup.sh`    | Provides IP address information.       |
| `pswgen.sh`      | Simple password generator.             |

### 🛠 Dotfiles Included
| Tool       | Description                                    |
| ---------- | ---------------------------------------------- |
| `wezterm`  | Custom terminal configuration (theme, fonts).  |
| `starship` | Fast, minimal, and highly customizable prompt. |


### 🧪 Contributing

Contributions are welcome! Feel free to open pull requests with useful Bash scripts or improvements to existing ones. Please make sure:

    Scripts are well-documented.

    You follow a consistent formatting style.

    Dotfiles are organized and include a brief README if needed.
