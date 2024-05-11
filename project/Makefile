#Compiler and Compile options.
CC = g++
CXXFLAGS = -g -Wall -std=c++11

SRCS := $(wildcard src/*.cc)
OBJS := $(SRCS:.cc=.o)
BIN = ./bin/
INC = ./include/
LIB = ./lib/ -lpthread

CPPFLAGS += -I$(INC)


TARGET = print_hello
$(TARGET): $(OBJS)
	$(CC) $(CXXFLAGS) $(CPPFLAGS) -o $(BIN)$(TARGET) $(OBJS) -L$(LIB)

clean:
	rm $(BIN)$(TARGET) $(OBJS)
