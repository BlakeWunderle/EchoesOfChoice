using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class ArcaneWard : Ability
    {
        public ArcaneWard()
        {
            Name = "Arcane Ward";
            FlavorText = "Inscribe protective runes that shield allies from harm.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
            TargetAll = true;
        }
    }
}
