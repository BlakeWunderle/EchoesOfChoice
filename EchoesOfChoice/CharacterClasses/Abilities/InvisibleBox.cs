using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class InvisibleBox : Ability
    {
        public InvisibleBox()
        {
            Name = "Invisible Box";
            FlavorText = "The enemy is trapped in an invisible box.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
