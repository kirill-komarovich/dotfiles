set -gx ANDROID_HOME $HOME/.android_sdk

if test -d $ANDROID_HOME; and test -d "$ANDROID_HOME/platform-tools"
  fish_add_path -gP "$ANDROID_HOME/platform-tools"
end
