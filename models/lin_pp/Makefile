CXX=g++
CXXFLAGS= -O3 -Wall -Werror -Wfatal-errors -std=c++11
RM=rm -rf
EXEC=ln_pp.exe

SRC:=$(wildcard *.cpp) 

.phony: clean

all: $(EXEC)

$(EXEC): $(patsubst %.s, %.o, $(SRC:%.cpp=%.o)) 
	$(CXX) $(CXXFLAGS) -o $@ $^

%.o: %.cpp *.hpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

clean:
	$(RM) $(EXEC) *.log *.o
