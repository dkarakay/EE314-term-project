import random

buffer1 = [4] * 6
buffer2 = [4] * 6
buffer3 = [4] * 6
buffer4 = [4] * 6
i = 0

while i < 5:
    random_buffer = random.randint(1, 4)
    random_input = random.randint(0, 3)

    if random_buffer == 1:
        buffer1[0] = random_input
    if random_buffer == 2:
        buffer2[0] = random_input
    if random_buffer == 3:
        buffer3[0] = random_input
    if random_buffer == 4:
        buffer4[0] = random_input
    print(random_buffer)
    print(buffer1)
    print(buffer2)
    print(buffer3)
    print(buffer4)
