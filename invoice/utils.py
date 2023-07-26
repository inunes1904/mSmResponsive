import base64

def stringToBase64(s):
    s = s.encode("ascii")
    base64_bytes = base64.b64encode(s)
    base64_string = base64_bytes.decode("ascii")
    return base64_string
    

def base64ToString(b):
    base64_string = b
    base64_bytes = base64_string.encode("ascii")
    sample_string_bytes = base64.b64decode(base64_bytes)
    sample_string = sample_string_bytes.decode("ascii")
    return sample_string
