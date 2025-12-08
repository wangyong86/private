use std::io;

fn main() {
    // tuple
    let tup = ( 10, 4.2, false );
    let (_, y, _) = tup;
    let t = tup.2;
    println!("tup value {y} {t}");

    // array
    let array1 = [1,2,3];
    let array2 = [3;5];
    let array3: [u32; 5] = [1, 2, 3, 4, 5];
    println!("tup value {} {} {}", array1[1], array2[2], array3[3]);


    let mut index = String::new();
    io::stdin()
        .read_line(&mut index)
        .expect("Failed to read line");

    let index :usize = index
        .trim()
        .parse()
        .expect("Not a number");

    let element = array1[index];

    println!("value is {element}");
}
