import 'package:flutter/material.dart';
import 'package:appdrinkify/controllers/navigation_controller.dart';

class CategoriasView extends StatelessWidget{
  const CategoriasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed:()=> NavigationController.navigateTo(context,'/home'),
            icon: const Icon(Icons.arrow_back),
          ),
        title: const Text('Explora distintas categorías'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    TextButton(
                      onPressed:()=> NavigationController.navigateTo(context,'/home'),
                        child: Image.network("https://www.gob.mx/cms/uploads/article/main_image/24844/aguas.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                    ),
                    const Text("Aguas frescas", style: TextStyle(fontSize: 20)),
                    
                    TextButton(
                      onPressed:()=> NavigationController.navigateTo(context,'/home'),
                        child: Image.network("https://lucavending.net/wp-content/uploads/2021/06/bebidas-calientes.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                    ),
                    const Text("Calientes", style: TextStyle(fontSize: 20)),

                    TextButton(
                      onPressed:()=> NavigationController.navigateTo(context,'/home'),
                        child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS14sRbtoDJIDz3SJ2t1vZ19R5LJhXpSSQIAA&s",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                    ),
                    const Text("Con alcohol", style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed:()=> NavigationController.navigateTo(context,'/home'),
                        child: Image.network("https://s3.amazonaws.com/takami.co/thumbnails/productimage/75399ce2ab6242d8a683d822963e874c/nmj5mo4az3ka7gbkp4ufge_1280_800.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                    ),
                    const Text("Jugos Clasicos", style: TextStyle(fontSize: 20)),

                    TextButton(
                      onPressed:()=> NavigationController.navigateTo(context,'/home'),
                        child: Image.network("https://media.gq.com.mx/photos/61e83673f4e647708c8d6205/16:9/w_2992,h_1683,c_limit/diaet-shakes-abnehm-trend-abnehmen-gesundheit-fitness-aufm.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                    ),
                    const Text("Jugos fitness", style: TextStyle(fontSize: 20)),
                    
                    TextButton(
                      onPressed:()=> NavigationController.navigateTo(context,'/home'),
                        child: Image.network("https://s2.abcstatics.com/media/bienestar/2020/07/04/batidos-saludables-kdhH--1248x698@abc.jpeg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,
                        ),
                    ),
                    const Text("Batidos", 
                    style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      //bottomNavigationBar: const BottomNavBar(),
    );
  }
}