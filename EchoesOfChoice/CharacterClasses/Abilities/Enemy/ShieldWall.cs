using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class ShieldWall : Ability
    {
        public ShieldWall()
        {
            Name = "Shield Wall";
            FlavorText = "Braces behind a disciplined formation. Increases defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 2;
        }
    }
}
