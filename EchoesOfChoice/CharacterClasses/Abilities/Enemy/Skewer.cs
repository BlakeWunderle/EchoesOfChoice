using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Skewer : Ability
    {
        public Skewer()
        {
            Name = "Skewer";
            FlavorText = "A vicious spear thrust aimed at the heart.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
