# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

if [[ -x /usr/bin/dircolors ]]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

alias du='du -h'
alias df='df -h'
alias ll='ls -l'
alias la='ls -lA'
alias l='ls'
alias sl='ls'
alias vi='vim'

# set PATH so it includes user's private ~/.local/bin if it exists
if [[ -d $HOME/.local/bin ]]; then
    PATH="$HOME/.local/bin:$PATH"
fi

lower_hostname=`hostname | tr '[:upper:]' '[:lower:]'`
current_uname=`uname -a`

if [[ $TERM =~ xterm-*(256)color ]]; then
	PS1='\[\033[01;34m\]\w\[\033[00m\]\$ '

	if [[ $current_uname != *Android* ]]; then
		PS1="${debian_chroot:+($debian_chroot) }\[\033[01;32m\]\u@$lower_hostname\[\033[00m\]:$PS1"
	fi
else
	PS1='\w\$ '

	if [[ $current_uname != *Android* ]]; then
		PS1="${debian_chroot:+($debian_chroot) }\u@$lower_hostname:$PS1"
	fi
fi

unset color_prompt

case "$TERM" in
xterm*|rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot) }\u@$lower_hostname: \w\a\]$PS1"
	;;
*)
	;;
esac

unset lower_hostname

if [[ $current_uname == *Cygwin* ]]; then
	# Cygwin
	dotnet_dir='/cygdrive/c/Windows/Microsoft.NET/Framework'

	if [[ $current_uname == *x86_64* ]]; then
		dotnet_dir="${dotnet_dir}64/"
	else
		dotnet_dir="${dotnet_dir}/"
	fi
	
	dotnet_flags=' /nologo'

	if [[ ! -x '/bin/cygwin-console-helper.exe' ]]; then
		function wincmd() {
			CMD=$1
			shift
			$CMD $* 2>&1 | iconv -f cp932 -t utf-8
		}

		dotnet_flags="$dotnet_flags /utf8output"
	fi

	alias csc2.0="${dotnet_dir}v2.0.50727/csc.exe$dotnet_flags"
	alias csc3.5="${dotnet_dir}v3.5/csc.exe$dotnet_flags"
	alias csc4.0="${dotnet_dir}v4.0.30319/csc.exe$dotnet_flags"

	unset dotnet_dir

	vs_dir='/cygdrive/c/Program Files (x86)/Microsoft Visual Studio/'
	vs_builder_path='/Community/MSBuild/'
	vs_csc_path='/Bin/Roslyn/csc.exe'

	alias csc='csc4.0'

	if [[ -x "${vs_dir}2017${vs_builder_path}15.0" ]]; then
		alias csc2017="\"${vs_dir}2017${vs_builder_path}15.0${vs_csc_path}\" ${dotnet_flags}"
		alias csc='csc2017'
	fi


	if [[ -x "${vs_dir}2019${vs_builder_path}Current" ]]; then
		alias csc2019="\"${vs_dir}2019${vs_builder_path}Current${vs_csc_path}\" ${dotnet_flags}"
		alias csc='csc2019'
	fi

	unset vs_dir
	unset vs_builder_path
	unset vs_csc_path

	unset dotnet_flags
elif [[ $current_uname == *Android* ]]; then
	# termux
	alias s='sshd -p 2222; hostname -I'
else
	# debian
	alias upd8='sudo sh -c ''apt update -y; apt upgrade -y;'''
fi

unset current_uname

