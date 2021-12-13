//Identify our license
// SPDX-License-Identifier: MIT
//Specify the version
pragma solidity >= 0.4.24 <0.8.11;
pragma experimental ABIEncoderV2;

// ------------------------------------------
// CANDIDATO | EDAD | ID
// ------------------------------------------
// Toni      |  20  | 12345X
// Alberto   |  23  | 54321T
// Joan      |  21  | 98765P
// Javier    |  19  | 56789W



contract votacion{

    //Direccion del propietario del contrato
    address public owner;

    //Constructor <- msg.sender nos devuelve un objeto de tipo address, es decir una direccion, de la persona que despliega el contrato
    constructor() public{
     owner = msg.sender;   
    }

    //Necesitamos algo que relacione el nombre con el hash de nuestros datos personales
    //Relacion entre el nombre del candidato y el hash de nuestros datos personales > string => bytes32 en un mapping

    mapping (string=>bytes32) id_Candidato;

    //En un momento vamos a querer ver cuantos votos tiene un candidato
    //Relacionar el candidato con el numero de votos del candidato

    mapping (string => uint) votos_Candidato;

    //Vamos a necesitar una lista de todos los candidatos, nos puede ser util para saber que personas se presentaron a ser electos en estas votaciones
    //Lista para almacenar los nombres de los candidatos

    string [] candidatos;

    //En algun momento vamos a tener que identificar a los votantes
    //Lista de los hashes de la identidad de los votantes,esta lista no va a contener el nombre de los votantes, va a almacenar su hash por la cual ha ejecutado el voto <- un hash nos devuelve un tipo de dato bytes
   
    bytes32 [] votantes;


    //Funcion que nos permite indicar que cualquier persona se pueda postular para que lo voten
    function Representantes(string memory _nombreRepresentante, uint _edadRepresentante, string memory _idRepresentante) public {
        //Calculamos el hash de los datos del candidato
        bytes32 hash_Candidato = keccak256(abi.encodePacked(_nombreRepresentante, _edadRepresentante, _idRepresentante));

        //Almacenar el hash de los datos del candidato que estan ligados a su nombre
        id_Candidato[_nombreRepresentante] = hash_Candidato;

        //Actualizamos la lista de los candidatos
        candidatos.push(_nombreRepresentante);
    }

    //Funcion que nos permite saber quienes son los que se postulan
    function visualizarCandidatos() public view returns (string [] memory){

        //Devuelve la lista de los candidatos presentados
        return candidatos;
    }


    //Funcion que nos permite votar a los candidatos
    function Votar(string memory _candidato) public {
        // Obtenemos el hash de la persona que va a ejecutar esta funcion
        bytes32 hash_Votante = keccak256(abi.encodePacked(msg.sender));
        
        //Verificamos si el votante ya realizado su voto anteriormente o no
        for(uint i=0; i<votantes.length; i++){
            require(votantes[i]!=hash_Votante, "¡Ya haz votado previamente!");
        }
        //Almacenamos el hash del votante dentro del array
        votantes.push(hash_Votante);
        
        //Añadimos un voto al candidato seleccionado por el votante
        votos_Candidato[_candidato]++;


    }

    //Funcion que nos permite visualizar la cantidad de votos de un candidato
    function visualizarVotos(string memory _candidato) public view returns(uint) {
        //Devolviendo el numero de votos del candidato especificado en el mapping votos_Candidato
        return votos_Candidato[_candidato];
    }

    //Funcion auxiliar que transforma un uint a un string

        function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
            if (_i == 0) {
                return "0";
            }
            uint j = _i;
            uint len;
            while (j != 0) {
                len++;
                j /= 10;
            }
            bytes memory bstr = new bytes(len);
            uint k = len - 1;
            while (_i != 0) {
                bstr[k--] = byte(uint8(48 + _i % 10));
                _i /= 10;
            }
            return string(bstr);
        }


    //Funcion que nos permite ver los votos de cada uno de los candidatos
    function visualizarResultados() public view returns(string memory) {
        
        //Guardamos en una variable string los candidatos con sus respectivos votos
        string memory Resultados="";
    
        //Recorremos el array de candidatos para actualizar el string resultados
        for(uint i=0; i<candidatos.length; i++){
            //Actualizamos el string resultados y añadimos el candidato que ocupa la posicion "i" del array candidatos
            //Añadimos tambien la cantidad de votos de ese candidato
            Resultados = string(abi.encodePacked(Resultados, "(", candidatos[i], ", ", uint2str(visualizarResultados(candidatos[i])), ") ------"));
        }
        //Devolvemos los resultados
        return Resultados;
        
    }


    //Funcion que nos devuelve el nombre con el candidato que tiene mas votos 
    function candidatoGanador() public view returns(string memory){
        
        //La variable ganador contiene el nombre del candidado ganador
        string memory ganador = candidatos[0];

        //Agregamos un bool por si hay un empate, asi cubrimos todos los escenarios
        bool flag;

        //Recorremos el array de candidatos para determinar el candidato con el mayor numero de votos
        for(uint i=1; i<candidatos.lenght; i++){
            
            //Comparamos si nuestro ganador ha sido superado por otro candidato
            if(votos_Candidatos[ganador] < votos_candidato[candidatos[i]]){
                ganador = candidatos[i];
                flag = false;
            }else{
                //Determinamos si hay un empate entre los candidatos
                if(votos_Candidatos[ganador] == votos_candidato[candidatos[i]]){
                flag = true;
            }
        }

    }
            //Comprobamos si hubo un empate entre los candidatos
            if(flag == true){
                //Informamos del empate
                ganador = "¡Hay un empate entre los candidatos!";
            }

            //Devolvemos el ganador
            return ganador;
    }
}