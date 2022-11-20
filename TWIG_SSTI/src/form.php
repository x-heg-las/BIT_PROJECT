<div class="container">
 <div class="row h-100 d-flex justify-content-center mt-5">
    <h3>Repport issue</h3>
    <form method="post" action="">
        <textarea name="review" class="form-control mb-3"></textarea>
        <div class="input-group">
            <input type="email" class="form-control" name="email" placeholder="Your email"/>
            <button class="btn btn-primary" type="submit">Send mail</button>
        </div>
    </form>
 </div>

<p class="py-3">
<?php


include('vendor/twig/twig/lib/Twig/Autoloader.php');
if(isset($_POST['email']) && isset($_POST['review'])) {
    Twig_Autoloader::register();
    try {
        $reporter = $_POST['email'];
        
        $loader = new Twig_Loader_String();
        $twig = new Twig_Environment($loader);
        $message =  $twig->render("Issue successfuly reporded from: $reporter ");

        echo $message;
    } catch (Exception $ex) {
        echo $ex->getMessage();
    }
}

?>

</p>
</div>