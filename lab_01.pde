import java.io.*;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.Scanner;

//Para obtener el contenido del portapapeles
import java.awt.datatransfer.*;
import java.awt.Toolkit;


String pythonExecutable;

void setup() {
  size(700, 600);
  inicializarGUI();


  textSize(16);
}

void draw(){
  mostrarGUI();
}
