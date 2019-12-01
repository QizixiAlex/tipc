#include "UnionFindSolver.h"

std::string UnionFindSolver::findRoot(std::string node_str) 
{
    addNode(node_str);
    while (node2root[node_str] != node_str) {
        node_str = node2root[node_str];
    }
    return node_str;
}

void UnionFindSolver::addNode(std::string node_str)
{
    if (node2root.find(node_str) == node2root.end()) {
        node2root[node_str] = node_str;
    }
    if (node2type.find(node_str) == node2type.end()) {
        node2type[node_str] = nullptr;
    }
}

void UnionFindSolver::unifyNodes(std::string nodex_str, std::string nodey_str)
{
    addNode(nodex_str);
    addNode(nodey_str);
    std::string rootx_str = findRoot(nodex_str);
    std::string rooty_str = findRoot(nodey_str);
    if (rootx_str == rooty_str) {
        return;
    }
    // rootx or rooty does not have a type yet
    if (node2type[rootx_str] == nullptr) {
        node2type[rootx_str] = node2type[rooty_str];
        node2root[rootx_str] = rooty_str;
        return;
    }
    if (node2type[rooty_str] == nullptr) {
        node2type[rooty_str] = node2type[rootx_str];
        node2root[rooty_str] = rootx_str;
        return;
    }
    // type mismatch
    if (!sameType(node2type[rootx_str], node2type[rooty_str])) {
        // TODO: move information from std::cout to logger
        std::ostringstream oss;
        oss << " Type error: " << nodex_str << " " << node2type[rootx_str]->print() << " does not match " << node2type[rooty_str]->print();
        std::string mismatch_information = oss.str();
        throw TIPTypeError(mismatch_information);
    } else {
        node2root[rootx_str] = rooty_str;
    }
}

void UnionFindSolver::setType(std::string node_str, TIPtype* type) 
{
    addNode(node_str);
    std::string root_str = findRoot(node_str);
    // root does not have type yet
    if (node2type[root_str] == 0) {
        node2type[root_str] = type;
        return;
    }
    // root type mismatch
    if (!sameType(node2type[root_str], type)) {
        // TODO: move information from std::cout to logger
        std::ostringstream oss;
        oss << " Type error: " << root_str << node2type[root_str]->print() << " does not match type: " << type->print();
        std::string mismatch_information = oss.str();
        throw TIPTypeError(mismatch_information);
    }
}

TIPtype* UnionFindSolver::getType(std::string node_str) 
{
    addNode(node_str);
    std::string root_str = findRoot(node_str);
    return node2type[root_str];
}

bool UnionFindSolver::sameType(TIPtype* typex, TIPtype* typey)
{
    if (typex == typey) {
        return true;
    }
    if (typex == nullptr || typey == nullptr) {
        return false;
    }
    //debug
    if (typex->print() != typey->print()) {
        std::string s1 = typex->print();
        std::string s2 = typey->print();
    }
    return typex->print() == typey->print();
}

