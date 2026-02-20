CXX			= g++
CXXFLAGS 	= -std=c++20 -Wall -Wextra -march=native -pedantic-errors -fdiagnostics-color=always -g
TARGET		= sudoku
SRCS		= main.cpp sudoku.cpp
OBJS		= $(SRCS:.cpp=.o)
HEADERS		= sudoku.hpp

all: $(TARGET)

debug: CXXFLAGS += -DDEBUG -g -O0 -fsanitize=address -D_GLIBCXX_DEBUG
debug: clean $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

%.o: %.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) -c $< -o $@

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET) $(OBJS)

.PHONY: all debug run clean
