import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { FileText, Briefcase } from "lucide-react";

const Onboarding = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen flex items-center justify-center bg-background p-4">
      <div className="max-w-4xl w-full space-y-8 text-center">
        <div className="space-y-4">
          <h1 className="text-5xl font-bold tracking-tight">
            Crée ton CV professionnel en 2 minutes
          </h1>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Génère des CV optimisés pour les ATS et les recruteurs grâce à l'intelligence artificielle
          </p>
        </div>

        <div className="grid md:grid-cols-2 gap-6 mt-12">
          <Card className="hover:shadow-lg transition-shadow cursor-pointer border-2 hover:border-accent">
            <CardContent className="p-8 space-y-4" onClick={() => navigate("/profile/general")}>
              <div className="w-16 h-16 rounded-xl bg-primary/10 flex items-center justify-center mx-auto">
                <FileText className="w-8 h-8 text-primary" />
              </div>
              <h2 className="text-2xl font-semibold">Créer un CV général</h2>
              <p className="text-muted-foreground">
                Crée un CV professionnel polyvalent que tu pourras personnaliser plus tard
              </p>
              <Button className="w-full" size="lg">
                Commencer
              </Button>
            </CardContent>
          </Card>

          <Card className="hover:shadow-lg transition-shadow cursor-pointer border-2 hover:border-accent">
            <CardContent className="p-8 space-y-4" onClick={() => navigate("/profile/job-based")}>
              <div className="w-16 h-16 rounded-xl bg-accent/10 flex items-center justify-center mx-auto">
                <Briefcase className="w-8 h-8 text-accent" />
              </div>
              <h2 className="text-2xl font-semibold">Créer un CV basé sur une offre</h2>
              <p className="text-muted-foreground">
                Analyse une offre d'emploi et génère un CV parfaitement adapté
              </p>
              <Button className="w-full" size="lg" variant="outline">
                Commencer
              </Button>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
};

export default Onboarding;
