using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class InvisibleWall : Ability
    {
        public InvisibleWall()
        {
            Name = "Invisible Wall";
            FlavorText = "Hands press against thin air and suddenly nothing can get through. Increases defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
