using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class PantomimeWall : Ability
    {
        public PantomimeWall()
        {
            Name = "Pantomime Wall";
            FlavorText = "Hands press against thin air -- nothing gets through. Increases defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
