def print_X(text, dashes=30):
    """Prettifyer for printing in Jypyter Notebook"""
    from math import ceil
    print("="*ceil(dashes - len(text)/2) + " " + text +" " +  "="*ceil(dashes - len(text)/2))
