from typing import List


def print_X(text: str, dashes: int = 30) -> None:
    """Prettifyer for printing in Jypyter Notebook"""
    from math import ceil
    print("="*ceil(dashes - len(text)/2) + " " +
          text + " " + "="*ceil(dashes - len(text)/2))


def delete_variables(variables_list):
    """
    Deletes variables passed as a list of variable names.
    """
    import inspect
    import gc
    frame = inspect.currentframe().f_back
    frame_locals = frame.f_locals
    frame_globals = frame.f_globals

    for variable_name in variables_list:
        # Check if the variable exists in locals()
        if variable_name in frame_locals:
            exec(f'del {variable_name}', frame_globals, frame_locals)
            print(f">>> Variable '{variable_name}'{'.'* (30 - len(variable_name))} deleted from locals().")
        # Check if the variable exists in globals()
        elif variable_name in frame_globals:
            exec(f'del {variable_name}', frame_globals, frame_globals)
            print(f">>> Variable '{variable_name}'{'.'* (30 - len(variable_name))} deleted from globals().")
        else:
            print(f">>> Variable '{variable_name}' does not exist.")
    gc.collect

