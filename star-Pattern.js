let row =4 ;
let column = 7 ;
let pattern = "";
let space = 0;
for (i=1; i<=row; i++) {
    for (z=1; z <= space; z++ ) {
        pattern += " "
    } 
    for (j=1; j <= column; j++ ) {
        pattern += "  *   "
    } 
    
    column -=2
    space += 5
    pattern += " \n "
}
console.log(pattern)