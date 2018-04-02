#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>
#include <cstdio>
#include <cmath>

using std::cout;
using std::endl;
using std::vector;
using std::string;

void print_help();
float get_iterp(vector<float> freqs);
float get_power(vector<float> freqs);

int main(int argc, char* argv[]) 
{

    if(argc != 2) {
        std::cout << "Invalid number of paramters!" << std::endl;
        exit(1);
    }

    float req_iter = atof(argv[1]);
    float epsilon = 1.0;
    float step_size = 0.01;
    int iter_no = 0;

    std::ofstream log_file;
    string fname = "run_" + std::to_string(req_iter) + ".log";
    log_file.open(fname);

    vector<float> freqs = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0};

    float iterp = get_iterp(freqs);
    float power = get_power(freqs);

    while((iterp > req_iter + epsilon) || (iterp < req_iter - epsilon)) {
        log_file << "Current iterp: " << iterp << ", Power: " << power << std::endl;
        log_file << "Required iterp: " << req_iter << std::endl;
        for(int i = 0; i < 7; i++) log_file << "F" << i << ": " << freqs[i] << ", ";
        log_file << std::endl;

        //if(iter_no == 5000) break;
        iter_no++;
        float diff = -1;
        float idx;
        int skip = 0;
        for(int i = 0; i < 7; i++) {
            freqs[i] = (iterp > req_iter) ? freqs[i] + step_size : freqs[i] - step_size;
            if(freqs[i] <= 0.0) {
                freqs[i] += step_size;
                skip++;
                continue;
            }
            else if(freqs[i] >= 1000.0) {
                freqs[i] -= step_size;
                skip++;
                continue;
            }
            float peek_ip = get_iterp(freqs);
            if(fabs(peek_ip - iterp) > diff) {
                diff = fabs(peek_ip - iterp);
                idx = i;
            }
            log_file << "Peek IP: " << peek_ip << ", diff: " << diff << ", idx: " << idx << std::endl;
            freqs[i] = (iterp > req_iter) ? freqs[i] - step_size : freqs[i] + step_size;
        }
        if(skip == 7) break;
        freqs[idx] = (iterp > req_iter) ? freqs[idx] + step_size : freqs[idx] - step_size;
        iterp = get_iterp(freqs);
        power = get_power(freqs);
    }

    std::cout << "Current iterp: " << iterp << ", Power: " << power << std::endl;
    for(int i = 0; i < 7; i++) std::cout << "F" << i << ": " << freqs[i] << ", ";
    std::cout << std::endl;

    return 0;
}

void print_help()
{
    std::cout << "TODO" << std::endl;
}

float get_iterp(vector<float> freqs)
{
    float iterp = 0.0;

    float buff_wrt[12];
    float buff_rdt[12];

    buff_rdt[0]  = 0.0;
    buff_rdt[8]  = buff_rdt[0];
    buff_wrt[1]  = (buff_rdt[0] > buff_rdt[8]) ? 15/freqs[0] + buff_rdt[0] : 15/freqs[0] + buff_rdt[8];
    buff_wrt[2]  = (buff_rdt[0] > buff_rdt[8]) ? 15/freqs[0] + buff_rdt[0] : 15/freqs[0] + buff_rdt[8];
    buff_rdt[1]  = buff_wrt[1] + 1/freqs[0]; 
    buff_rdt[2]  = buff_wrt[1] + 1/freqs[0]; 
    buff_rdt[11] = buff_rdt[1];
    buff_wrt[4]  = (buff_rdt[1] > buff_rdt[11]) ? 15/freqs[1] + buff_rdt[1] : 15/freqs[1] + buff_rdt[11];
    buff_wrt[3]  = 15/freqs[2] + buff_rdt[2];
    buff_wrt[5]  = 15/freqs[2] + buff_rdt[2];
    buff_rdt[4]  = buff_wrt[4] + 1/freqs[1];
    buff_rdt[5]  = buff_wrt[5] + 1/freqs[2];
    buff_rdt[3]  = buff_wrt[3] + 1/freqs[2];
    buff_wrt[6]  = (buff_rdt[4] > buff_rdt[5]) ? 15/freqs[4] + buff_rdt[4] : 15/freqs[4] + buff_rdt[5];
    buff_wrt[7]  = 15/freqs[3] + buff_rdt[3];
    buff_wrt[8]  = 15/freqs[3] + buff_rdt[3];
    buff_rdt[6]  = buff_wrt[6] + 1/freqs[4];
    buff_rdt[7]  = buff_wrt[7] + 1/freqs[3];
    buff_rdt[8]  = buff_wrt[8] + 1/freqs[3];
    buff_wrt[9]  = (buff_rdt[6] > buff_rdt[7]) ? 15/freqs[5] + buff_rdt[6] : 15/freqs[5] + buff_rdt[7];
    buff_rdt[9]  = buff_wrt[9] + 1/freqs[5];
    buff_wrt[10] = buff_rdt[9] + 15/freqs[6];
    buff_wrt[11] = buff_rdt[9] + 15/freqs[6];

    iterp = buff_wrt[10] - 15/freqs[0];

    return iterp;
}

float get_power(vector<float> freqs)
{
    float power = 0.0;

    for(auto freq : freqs) {
        power += freq;
    }

    return power;

}
