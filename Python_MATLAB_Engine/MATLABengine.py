# REF: this file will test the matlab engine for python.

import matlab.engine

# NOTE: start the matlab engine
eng = matlab.engine.start_matlab()

# NOTE: call a matlab function
tf = eng.isprime(37)
print(tf)


# NOTE: close the matlab engine
eng.quit()