test -r /Users/fco/.alias && source /Users/fco/.alias
setopt PROMPT_SUBST
PS1='GRASS : %1~ > '
grass_prompt() {
    MAPSET_PATH="`g.gisenv get=GISDBASE,LOCATION_NAME,MAPSET separator='/'`"
    _GRASS_DB_PLACE="`g.gisenv get=LOCATION_NAME,MAPSET separator='/'`"
    
    local z_lo=`g.gisenv get=LOCATION_NAME`
    local z_ms=`g.gisenv get=MAPSET`
    ZLOC="Mapset <$z_ms> in <$z_lo>"
    if [ "$_grass_old_mapset" != "$MAPSET_PATH" ] ; then
        fc -A -I
        HISTFILE="$MAPSET_PATH/.zsh_history"
        fc -R
        _grass_old_mapset="$MAPSET_PATH"
    fi
    
    if test -f "$MAPSET_PATH/cell/MASK" && test -d "$MAPSET_PATH/grid3/RASTER3D_MASK" ; then
        echo "[2D and 3D raster MASKs present]"
    elif test -f "$MAPSET_PATH/cell/MASK" ; then
        echo "[Raster MASK present]"
    elif test -d "$MAPSET_PATH/grid3/RASTER3D_MASK" ; then
        echo "[3D raster MASK present]"
    fi
}
PROMPT_COMMAND=grass_prompt
precmd() { eval "$PROMPT_COMMAND" }
RPROMPT='${ZLOC}'
export HOME="/Users/fco"
export PATH="/Applications/GRASS-8.2.app/Contents/Resources/bin:/Applications/GRASS-8.2.app/Contents/Resources/scripts:/Users/fco/Library/GRASS/8.2/Addons/bin:/Users/fco/Library/GRASS/8.2/Addons/scripts:/opt/homebrew/bin:/opt/anaconda3/bin:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
trap "exit" TERM
