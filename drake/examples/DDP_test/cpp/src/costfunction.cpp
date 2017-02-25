#include "costfunction.h"

CostFunction::CostFunction()
{
	// Q << 100.0,0.0,0.0,0.0,
 //                0.0,0.0,0.0,0.0,
 //                0.0,0.0,0.0,0.0,
 //                0.0,0.0,0.0,0.0;
 //    R << 0.1;

 //    Qf = Q;
}

stateVec_t& CostFunction::getlx()
{
    return lx;
}

stateMat_t& CostFunction::getlxx()
{
    return lxx;
}

commandVec_t& CostFunction::getlu()
{
    return lu;
}

commandMat_t& CostFunction::getluu()
{
    return luu;
}

commandR_stateC_t& CostFunction::getlux()
{
    return lux;
}

stateR_commandC_t& CostFunction::getlxu()
{
    return lxu;
}

stateMat_t& CostFunction::getQ()
{
    return Q;
}

stateMat_t& CostFunction::getQf()
{
    return Qf;
}

commandMat_t& CostFunction::getR()
{
    return R;
}