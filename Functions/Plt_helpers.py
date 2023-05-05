def add_data_label(plot, x,y, backgrColor=None, fontColor='grey', shift_x=0, shift_y=0):
    
    bbox_dict = None if backgrColor is None else {'boxstyle':'round', 'pad':0.5, 'fc':backgrColor, 'edgecolor':'none','alpha':0.5}
    plot.annotate(
        f"{y}",
        xy=(x, y),
        xytext=(x-1+shift_x, y+10+shift_y),
        fontsize=12,
        color=fontColor,
        bbox=bbox_dict
    )
