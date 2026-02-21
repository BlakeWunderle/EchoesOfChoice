using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class AncestralWard : Ability
    {
        public AncestralWard()
        {
            Name = "Ancestral Ward";
            FlavorText = "The spirits of ancestors form a protective barrier around an ally.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
