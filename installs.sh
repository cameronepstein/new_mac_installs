install_homebrew() {
  printf "Installing Homebrew...\n"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

prompt_homebrew() {
  printf "Nothing is brewing.\nDo you want to install Homebrew? (y/n)? " && read choice
  case "$choice" in
    y|Y ) install_homebrew;;
    n|N ) printf "Fine. Whatever you say!";;
    * ) printf "You had ONE job.. FFS! Yes or no... KILL YOURSELF!!!";;
  esac
}

install_homebrew_package() {
  brew install ${1}
  printf "\n"
}

prompt_homebrew_package() {
  printf "${1} is not installed.\nDo you want to install it? (y/n)? " && read choice
  printf "\n"
  case "$choice" in
    y|Y ) install_homebrew_package $1;;
    n|N ) printf "OK. I won't install it.\n";;
    * ) printf "You had ONE job.. FFS! Yes or no...\n";;
  esac
}

check_brew_installed() {
  if brew ls --versions $1 > /dev/null; then
    printf "${1} installed. Skipping...\n";
  else
    prompt_homebrew_package $1
  fi
}

macos_install() {
    if [ ! `command -v brew` ]; then
          prompt_homebrew
        fi

        if [ `command -v brew` ]; then
          declare -a homebrew_packages=(
            "awscli"
            "bash"
            "bash-completion@2"
            "cocoapods"
            "direnv"
            "django-completion"
            "gpgme"
            "postgresql"
            "python@3"
            "python@2"
            "pip-completion"
            "thefuck"
            )
          for i in "${homebrew_packages[@]}"
          do
            check_brew_installed ${i}
          done
        fi

        if [ -f /usr/local/bin/bash ] && [ ! $SHELL = "/usr/local/bin/bash" ]; then
          printf "/usr/local/bin/bash" >> /etc/shells
          chsh -s /usr/local/bin/bash
          exec /usr/local/bin/bash
        fi

}
